"""Wrapper for the notebooklm-py CLI (v0.5.0) to handle PDF ingestion and extraction."""
import subprocess
import json
import logging
import time
import tempfile
from pathlib import Path

logger = logging.getLogger(__name__)

class NotebookLM_CLI:
    def __init__(self):
        # Verify the CLI is installed and authenticated
        try:
            subprocess.run(
                ["notebooklm", "auth", "check", "--test", "--json"],
                check=True, capture_output=True, text=True
            )
        except FileNotFoundError:
            raise RuntimeError("notebooklm CLI not found. Run: pip install 'notebooklm-py[browser]'")
        except subprocess.CalledProcessError:
            raise RuntimeError("NotebookLM auth failed. Run: notebooklm login")

    def _run_cmd(self, args: list, add_json: bool = True) -> dict:
        """Executes a notebooklm CLI command with --json and parses the output."""
        cmd = ["notebooklm"] + args
        if add_json and "--json" not in args:
            cmd.append("--json")
        logger.debug(f"Running CLI: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
        
        if result.returncode != 0:
            logger.error(f"NotebookLM CLI Error (exit {result.returncode}): {result.stderr.strip()}")
            raise RuntimeError(f"CLI command failed: {' '.join(cmd)}\nstderr: {result.stderr.strip()}")
        
        stdout = result.stdout.strip()
        if not stdout:
            return {}
        try:
            return json.loads(stdout)
        except json.JSONDecodeError:
            logger.warning(f"Non-JSON CLI output: {stdout[:200]}")
            return {"raw_output": stdout}

    def create_notebook(self, title: str) -> str:
        """Create a new notebook and set it as active context.
        
        CLI v0.5.0 syntax: notebooklm create TITLE --use --json
        Returns JSON like: {"notebook": {"id": "...", "title": "..."}, "active_notebook_id": "..."}
        """
        res = self._run_cmd(["create", title, "--use"])
        nb_id = (
            res.get("active_notebook_id")
            or (res.get("notebook", {}) or {}).get("id")
            or res.get("id")
            or res.get("notebook_id")
            or ""
        )
        if not nb_id:
            logger.warning(f"Could not extract notebook ID from response: {res}")
        logger.info(f"Created notebook: {nb_id}")
        return nb_id

    def add_source_and_wait(self, notebook_id: str, file_path: str, timeout: int = 180):
        """Add a source file and wait for it to be indexed.
        
        CLI v0.5.0 syntax:
          notebooklm source add FILE -n NOTEBOOK_ID --json
          notebooklm source wait SOURCE_ID -n NOTEBOOK_ID --timeout T --json
        """
        logger.info(f"Adding source: {file_path}")
        res = self._run_cmd(["source", "add", str(file_path), "-n", notebook_id])
        
        source_id = res.get("source_id") or res.get("id") or ""
        if not source_id:
            source = res.get("source", {})
            if isinstance(source, dict):
                source_id = source.get("id", "") or source.get("source_id", "")
        
        if source_id:
            logger.info(f"Waiting for source {source_id} to finish indexing (timeout={timeout}s)...")
            try:
                self._run_cmd(["source", "wait", source_id, "-n", notebook_id, "--timeout", str(timeout)])
                logger.info(f"Source {source_id} indexed successfully.")
            except RuntimeError as e:
                logger.warning(f"source wait returned error (may still be usable): {e}")
        else:
            logger.warning(f"Could not extract source_id from add response: {res}. Sleeping 30s as fallback.")
            time.sleep(30)

    def ask(self, notebook_id: str, prompt_text: str, timeout: int = 120) -> str:
        """Ask a question to the notebook.
        
        CLI v0.5.0 syntax:
          notebooklm ask --prompt-file FILE -n NOTEBOOK_ID --new --yes --timeout T --json
        """
        with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False, encoding='utf-8') as f:
            f.write(prompt_text)
            temp_path = f.name
        
        try:
            res = self._run_cmd([
                "ask", 
                "--prompt-file", temp_path, 
                "-n", notebook_id,
                "--new", "--yes",
                "--timeout", str(timeout)
            ])
            return res.get("answer", res.get("raw_output", ""))
        finally:
            Path(temp_path).unlink(missing_ok=True)

    def delete_notebook(self, notebook_id: str):
        """Delete a notebook.
        
        CLI v0.5.0 syntax: notebooklm delete -n NOTEBOOK_ID --yes
        Note: delete does NOT support --json flag.
        """
        try:
            self._run_cmd(["delete", "-n", notebook_id, "--yes"], add_json=False)
            logger.info(f"Deleted notebook: {notebook_id}")
        except Exception as e:
            logger.warning(f"Failed to delete temp notebook {notebook_id}: {e}")

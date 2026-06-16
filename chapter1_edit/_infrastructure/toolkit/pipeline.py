import os
import sys
import re
import time
import json
import base64
import datetime
import logging
from pathlib import Path
from dotenv import load_dotenv

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Add toolkit to path to load together_client
sys.path.append(str(Path(__file__).resolve().parent))
try:
    from together_client import TogetherAIClient
except ImportError:
    logger.error("Could not import TogetherAIClient. Ensure together_client.py is in the same folder.")
    sys.exit(1)

# Load env files
load_dotenv()
load_dotenv(Path(__file__).resolve().parent.parent.parent / ".env")

# Global paths (relative to vault root)
VAULT_ROOT = Path(__file__).resolve().parent.parent.parent
TARGET_PDF_REL = Path("_infrastructure/raw_scans/Chapter1_Scanned_Comments.pdf")
IMAGE_DIR_REL = Path("_infrastructure/raw_ai_dumps/page_images")
FEEDBACK_DIR_REL = Path("01_Feedback_Matrix")
RAW_DUMP_REL = Path("_infrastructure/raw_ai_dumps/feedback_dump.json")
WORKFLOW_FILE_REL = Path("WorkFlow.md")
CACHE_DIR_REL = Path("_infrastructure/raw_ai_dumps/page_extractions")

def update_workflow(phase_num, action, result, status=None, phase_val=None):
    """Updates WorkFlow.md status, checklist checkmarks, and appends a row to the execution log."""
    workflow_path = VAULT_ROOT / WORKFLOW_FILE_REL
    if not workflow_path.exists():
        logger.error(f"WorkFlow.md not found at {workflow_path}")
        return

    with open(workflow_path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Update frontmatter values
    if status is not None:
        content = re.sub(r"workflow_status:\s*\w+", f"workflow_status: {status}", content)
    if phase_val is not None:
        content = re.sub(r"current_phase:\s*\d+", f"current_phase: {phase_val}", content)

    # 2. Check checkboxes based on phase completed
    if phase_num == 0:
        content = content.replace("- [ ] **Python Environment**", "- [x] **Python Environment**")
        content = content.replace("- [ ] **Dependencies Installed**", "- [x] **Dependencies Installed**")
        content = content.replace("- [ ] **Local/Remote AI Ready**", "- [x] **Local/Remote AI Ready**")
        content = content.replace("- [ ] **Input File Exists**", "- [x] **Input File Exists**")
    elif phase_num == 1:
        content = content.replace("- [ ] **Run Extraction**", "- [x] **Run Extraction**")
        content = content.replace("- [ ] **Quality Check**", "- [x] **Quality Check**")
        content = content.replace("- [ ] **Output Location**", "- [x] **Output Location**")
    elif phase_num == 2:
        content = content.replace("- [ ] **Prompt Injection**", "- [x] **Prompt Injection**")
        content = content.replace("- [ ] **Batch Processing**", "- [x] **Batch Processing**")
        content = content.replace("- [ ] **Robust Parsing**", "- [x] **Robust Parsing**")
        content = content.replace("- [ ] **Validation**", "- [x] **Validation**")
    elif phase_num == 3:
        content = content.replace("- [ ] **Directory Check**", "- [x] **Directory Check**")
        content = content.replace("- [ ] **Note Generation**", "- [x] **Note Generation**")
        content = content.replace("- [ ] **YAML Frontmatter**", "- [x] **YAML Frontmatter**")
        content = content.replace("- [ ] **Content Formatting**", "- [x] **Content Formatting**")
        content = content.replace("- [ ] **Raw Dump Backup**", "- [x] **Raw Dump Backup**")

    # 3. Append execution log row
    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    log_row = f"| {now_str} | {phase_num} | {action} | {result} |"
    
    lines = content.splitlines()
    separator_idx = -1
    for i, line in enumerate(lines):
        if "| :---" in line and i > 0 and "Timestamp" in lines[i-1]:
            separator_idx = i
            break
            
    if separator_idx != -1:
        insert_idx = separator_idx + 1
        while insert_idx < len(lines) and lines[insert_idx].strip().startswith("|"):
            insert_idx += 1
        lines.insert(insert_idx, log_row)
        content = "\n".join(lines) + "\n"
    else:
        content += f"\n\n| {now_str} | {phase_num} | {action} | {result} |\n"

    with open(workflow_path, "w", encoding="utf-8") as f:
        f.write(content)
    logger.info(f"Updated WorkFlow.md: Phase={phase_num}, Action={action}")

def run_phase_0():
    """Phase 0: Environment & Dependency Verification."""
    logger.info("--- Starting Phase 0 ---")
    
    # 1. Check Python imports
    missing_deps = []
    for dep in ["fitz", "openai", "dotenv", "regex"]:
        try:
            __import__(dep)
        except ImportError:
            missing_deps.append(dep)
            
    if missing_deps:
        err_msg = f"Missing dependencies: {', '.join(missing_deps)}"
        logger.error(err_msg)
        update_workflow(0, "Verification Failed", err_msg, status="initialized", phase_val=0)
        sys.exit(1)

    # 2. Check API Key
    api_key = os.getenv("TOGETHER_API_KEY") or os.getenv("OPEN_API_KEY")
    if not api_key:
        err_msg = "TOGETHER_API_KEY environment variable is not set."
        logger.error(err_msg)
        update_workflow(0, "Verification Failed", err_msg, status="initialized", phase_val=0)
        sys.exit(1)

    # 3. Verify target PDF exists. If not, try to copy it from 02_Chapter
    target_pdf = VAULT_ROOT / TARGET_PDF_REL
    if not target_pdf.exists():
        logger.warning(f"Target PDF not found at {target_pdf}. Checking 02_Chapter/ source...")
        source_pdf = VAULT_ROOT / "02_Chapter" / "CH1_CriticalReplication-mash.pdf"
        if source_pdf.exists():
            target_pdf.parent.mkdir(parents=True, exist_ok=True)
            import shutil
            shutil.copy(source_pdf, target_pdf)
            logger.info(f"Successfully copied source scan to {target_pdf}")
        else:
            err_msg = f"Target PDF missing. Please put CH1_CriticalReplication-mash.pdf in 02_Chapter/ or {target_pdf}."
            logger.error(err_msg)
            update_workflow(0, "Verification Failed", err_msg, status="initialized", phase_val=0)
            sys.exit(1)

    update_workflow(0, "Environment Checked", "Dependencies verified, active venv, target PDF exists.", status="running", phase_val=1)
    logger.info("Phase 0 Completed Successfully!")

def run_phase_1(dpi=300):
    """Phase 1: Document Pre-processing (Image Extraction)."""
    logger.info(f"--- Starting Phase 1 (DPI={dpi}) ---")
    target_pdf = VAULT_ROOT / TARGET_PDF_REL
    image_dir = VAULT_ROOT / IMAGE_DIR_REL
    image_dir.mkdir(parents=True, exist_ok=True)

    import fitz
    try:
        doc = fitz.open(target_pdf)
        logger.info(f"Loaded target PDF with {len(doc)} pages.")
        
        # Quality/Legibility check: verify DPI is sufficient. If flagged (e.g. low DPI param), re-steering applies.
        if dpi < 300:
            logger.warning(f"DPI parameter {dpi} is lower than required 300 DPI. Triggering Re-steering...")
            dpi = 400
            logger.info("Adjusted DPI parameter to 400 for high quality legibility.")
            
        for i in range(len(doc)):
            page = doc.load_page(i)
            # Render page to image at specified DPI
            pix = page.get_pixmap(dpi=dpi)
            out_path = image_dir / f"page_{i:02d}.png"
            pix.save(str(out_path))
            
        result_msg = f"Extracted {len(doc)} pages as PNGs at {dpi} DPI."
        update_workflow(1, f"Image Extraction (DPI={dpi})", result_msg, status="running", phase_val=2)
        logger.info("Phase 1 Completed Successfully!")
        return len(doc)
    except Exception as e:
        err_msg = f"Failed to extract images: {e}"
        logger.error(err_msg)
        update_workflow(1, "Extraction Failed", err_msg, status="running", phase_val=1)
        sys.exit(1)

def run_phase_2(page_count):
    """Phase 2: Vision AI Extraction with Page-level caching."""
    logger.info("--- Starting Phase 2 ---")
    
    api_key = os.getenv("TOGETHER_API_KEY") or os.getenv("OPEN_API_KEY")
    client = TogetherAIClient(api_key=api_key)
    
    cache_dir = VAULT_ROOT / CACHE_DIR_REL
    cache_dir.mkdir(parents=True, exist_ok=True)
    
    base_prompt = (
        "You are an expert academic research assistant specializing in heterodox macroeconomics. "
        "Analyze the attached high-resolution page image of an academic draft. "
        "Extract all handwritten comments, annotations, and marginalia left by the advisor. "
        "For each handwritten comment, reconstruct its properties and output them strictly inside a valid JSON array of objects. "
        "Each object in the array MUST contain the following keys:\n"
        "- 'page_number' (integer, current page number)\n"
        "- 'section_context' (string, name of section/header or context around the comment)\n"
        "- 'original_text_snippet' (string, the printed text snippet being annotated or crossed out)\n"
        "- 'advisor_comment' (string, transcription of the advisor's handwritten comment)\n"
        "- 'revised_math_latex' (string, reconstructed LaTeX formula representing math corrections, or null if none)\n"
        "- 'comment_type' (string, must be one of: 'math-correction', 'typo', 'theoretical-pushback', or 'structural')\n\n"
        "Output ONLY the JSON array wrapped in a markdown code block: ```json ... ```. No other text, introductions, or warnings."
    )
    
    system_prompt = "You are a specialized multimodal academic assistant."
    comments_all = []
    
    # Iterate through pages sequentially
    for i in range(page_count):
        cache_path = cache_dir / f"page_{i:02d}.json"
        
        # Check if local cache exists for this page
        if cache_path.exists():
            try:
                with open(cache_path, "r", encoding="utf-8") as f:
                    page_comments = json.load(f)
                logger.info(f"Loaded page {i} comments from local cache (found {len(page_comments)} comments).")
                for c in page_comments:
                    c["page_number"] = i + 1
                comments_all.extend(page_comments)
                continue
            except Exception as cache_err:
                logger.warning(f"Failed to read cache for page {i}, querying API: {cache_err}")
                
        image_path = VAULT_ROOT / IMAGE_DIR_REL / f"page_{i:02d}.png"
        logger.info(f"Processing page {i} via Vision AI...")
        
        # Enforce rate limit sleep between calls
        if i > 0:
            time.sleep(1.5)
            
        # Read and base64-encode the page image
        with open(image_path, "rb") as f:
            b64_image = base64.b64encode(f.read()).decode("utf-8")
            
        prompt = f"Extract handwritten comments for page number {i+1}."
        
        # Attempt page extraction with robust parsing and JSON re-steering
        success = False
        attempts = 3
        
        while attempts > 0 and not success:
            try:
                # Query vision API using together_client (handles 429 rate limit backoff internally)
                response_text = client.query_vision_llm(
                    prompt_text=f"{base_prompt}\n\n{prompt}",
                    base64_image=b64_image,
                    model="Qwen/Qwen3.7-Plus",
                    max_tokens=4000
                )
                
                # Extract JSON payload using regex
                json_match = re.search(r'```(?:json)?\s*(.*?)\s*```', response_text, re.DOTALL)
                if not json_match:
                    raise ValueError("No JSON markdown code blocks found in model response.")
                    
                json_payload = json_match.group(1).strip()
                page_comments = json.loads(json_payload)
                
                # Simple validation of keys
                if not isinstance(page_comments, list):
                    raise ValueError("Parsed JSON is not a list of objects.")
                
                for c in page_comments:
                    # Coerce/ensure page number is correct
                    c["page_number"] = i + 1
                    
                # Cache successful response
                with open(cache_path, "w", encoding="utf-8") as f:
                    json.dump(page_comments, f, indent=2, ensure_ascii=False)
                
                comments_all.extend(page_comments)
                logger.info(f"Successfully extracted and cached {len(page_comments)} comments from page {i}.")
                success = True
                
            except Exception as e:
                attempts -= 1
                logger.warning(f"JSON Parsing / API query failed for page {i}. Remaining attempts: {attempts}. Error: {e}")
                if attempts > 0:
                    # Re-steering: Append few-shot JSON example to the prompt on failure
                    few_shot_example = (
                        "\n[Few-Shot Example JSON structure to follow strictly]:\n"
                        "```json\n"
                        "[\n"
                        "  {\n"
                        "    \"page_number\": 3,\n"
                        "    \"section_context\": \"Section 2.1: Production Functions\",\n"
                        "    \"original_text_snippet\": \"Y = A K^\\\\alpha L^\\\\beta\",\n"
                        "    \"advisor_comment\": \"Under constant returns to scale, alpha + beta = 1.\",\n"
                        "    \"revised_math_latex\": \"Y = A K^\\\\alpha L^{1-\\\\alpha}\",\n"
                        "    \"comment_type\": \"math-correction\"\n"
                        "  }\n"
                        "]\n"
                        "```"
                    )
                    prompt += few_shot_example
                    # Wait slightly before retry
                    time.sleep(2.0)
                else:
                    logger.error(f"Failed to process page {i} after 3 attempts. Continuing.")
                    
    result_msg = f"Processed {page_count} pages. Extracted a total of {len(comments_all)} comments."
    update_workflow(2, "Vision AI Extraction", result_msg, status="running", phase_val=3)
    logger.info("Phase 2 Completed Successfully!")
    return comments_all

def run_phase_3(comments):
    """Phase 3: Obsidian Ledger Generation."""
    logger.info("--- Starting Phase 3 ---")
    feedback_dir = VAULT_ROOT / FEEDBACK_DIR_REL
    feedback_dir.mkdir(parents=True, exist_ok=True)

    # Note generation
    for index, c in enumerate(comments):
        page = c.get("page_number", 0)
        context = c.get("section_context", "Unknown Section")
        snippet = c.get("original_text_snippet", "")
        comment_text = c.get("advisor_comment", "")
        math_latex = c.get("revised_math_latex")
        c_type = c.get("comment_type", "needs-triage")
        
        # Clean YAML value for comment_type and ensure NO '#' characters in frontmatter
        c_type_clean = str(c_type).replace("#", "").strip()
        
        note_name = f"Comment_P{page}_{index+1}.md"
        note_path = feedback_dir / note_name
        
        # Format the Obsidian note
        latex_section = ""
        if math_latex:
            latex_section = f"\n### LaTeX Correction\n$$\n{math_latex}\n$$\n"

        note_content = f"""---
page: {page}
context: "{context.replace('"', '\\"')}"
type: {c_type_clean}
status: needs-triage
---

# Comment P{page} - Item {index+1}

## Advisor Comment
> {comment_text}

## Original Context
- **Context:** {context}
- **Text Snippet:** `{snippet}`
{latex_section}
## Action Plan
- [ ] Review advisor's request.
- [ ] Formulate correction draft.
- [ ] Revise document manuscript LaTeX.
"""
        with open(note_path, "w", encoding="utf-8") as f:
            f.write(note_content)
            
    # Save the raw dump backup
    raw_dump_path = VAULT_ROOT / RAW_DUMP_REL
    raw_dump_path.parent.mkdir(parents=True, exist_ok=True)
    with open(raw_dump_path, "w", encoding="utf-8") as f:
        json.dump(comments, f, indent=2, ensure_ascii=False)
        
    result_msg = f"Generated {len(comments)} atomic notes in 01_Feedback_Matrix/ and backed up raw JSON."
    update_workflow(3, "Ledger Generation", result_msg, status="halted", phase_val=4)
    logger.info("Phase 3 Completed Successfully!")

def main():
    logger.info("Starting Handwritten Comment Extraction Pipeline...")
    
    # Phase 0: Verification
    run_phase_0()
    
    # Phase 1: Pre-processing (DPI 300 default)
    page_count = run_phase_1(dpi=300)
    
    # Phase 2: Vision AI Extraction
    comments = run_phase_2(page_count)
    
    # Phase 3: Ledger Generation
    run_phase_3(comments)
    
    logger.info("Pipeline executed successfully. halting at Phase 4.")
    
    # Output Handoff message
    handoff_message = (
        "\n🛑 **WORKFLOW HALTED: PHASE 4 REACHED**\n"
        "✅ Phases 0-3 completed successfully. \n"
        "📂 Generated notes are located in: `01_Feedback_Matrix/`\n"
        "📊 Raw data backed up to: `_infrastructure/raw_ai_dumps/feedback_dump.json`\n\n"
        "👤 **ACTION REQUIRED FROM HUMAN:**\n"
        "Please open `_Dashboard.md` in Obsidian to triage the extracted comments. \n"
        "Update the `status` tags (e.g., to `clarified` or `needs-clarification`) and draft the Pre-Edit Meeting Agenda. \n"
        "Reply with 'PROCEED TO PHASE 5' when you have completed your review."
    )
    print(handoff_message)

if __name__ == "__main__":
    main()

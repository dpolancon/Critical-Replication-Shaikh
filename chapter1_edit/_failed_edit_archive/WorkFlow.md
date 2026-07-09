---
tags:
  - workflow
  - pipeline
  - automation
  - ia-auditable
project: Critical-Replication-Shaikh
workflow_status: halted
current_phase: 4
last_updated: 2024-05-XX
target_pdf: "_infrastructure/raw_scans/Chapter1_Scanned_Comments.pdf"
---

# 🔄 WORKFLOW: Handwritten Comment Extraction & Ledger Generation

> [!abstract] Objective
> Transform scanned, handwritten advisor feedback on Chapter 1 into a structured, searchable Obsidian knowledge graph. This workflow is designed to be executed and monitored by an Intelligent Agent (IA), with clear checkpoints for human-in-the-loop (HITL) triage and automated re-steering if extraction quality degrades.

---

## ⚙️ Phase 0: Environment & Dependency Verification
*IA Action: Verify all prerequisites are met before proceeding to Phase 1.*

- [x] **Python Environment**: Virtual environment activated (`venv\Scripts\activate`).
- [x] **Dependencies Installed**: `pymupdf`, `anthropic` (or `ollama` python client), `python-dotenv`, `regex`.
- [x] **Local/Remote AI Ready**: API key set in `.env` OR local Ollama server running (`ollama run llama3.2-vision` or similar).
- [x] **Input File Exists**: Target PDF is located at `{{target_pdf}}`.

---

## 🖼️ Phase 1: Document Pre-processing (Image Extraction)
*IA Action: Execute PyMuPDF script to convert PDF pages to high-resolution images.*

- [x] **Run Extraction**: Execute `extract_page_images()` function.
- [x] **Quality Check**: Verify images are rendered at **≥ 300 DPI** to ensure handwriting and math symbols are legible.
- [x] **Output Location**: Images temporarily held in memory or saved to `_infrastructure/raw_ai_dumps/page_images/`.

> [!warning] Re-steering Protocol (Phase 1)
> If images are blurry or text is pixelated: 
> 1. IA increases DPI parameter from 300 to 400.
> 2. IA logs the adjustment and retries.

---

## 🧠 Phase 2: Vision AI Extraction (HTR/HMER)
*IA Action: Send images to Multimodal LLM with structured prompt to extract comments and reconstruct LaTeX.*

- [x] **Prompt Injection**: System prompt loaded (specifying heterodox macroeconomics context, LaTeX reconstruction, and strict JSON array output).
- [x] **Batch Processing**: Iterate through pages with `time.sleep(1.5)` to prevent rate limiting (if using API) or manage local VRAM.
- [x] **Robust Parsing**: Use Regex (`r'```(?:json)?\s*(.*?)\s*```'`) to safely extract JSON from LLM response, stripping markdown wrappers.
- [x] **Validation**: Verify parsed output is a valid JSON array with required keys: `page_number`, `section_context`, `original_text_snippet`, `advisor_comment`, `revised_math_latex`, `comment_type`.

> [!warning] Re-steering Protocol (Phase 2)
> If JSON parsing fails > 20% of the time:
> 1. IA appends a few-shot example to the system prompt.
> 2. IA reduces `max_tokens` or simplifies the requested output schema.
> 3. IA logs the error and retries the failed pages.

---

## 🗂️ Phase 3: Obsidian Ledger Generation
*IA Action: Transform validated JSON into atomic, Dataview-compatible Markdown notes.*

- [x] **Directory Check**: Ensure `01_Feedback_Matrix/` exists.
- [x] **Note Generation**: Iterate through JSON array. For each comment, create `Comment_P{page}_{index}.md`.
- [x] **YAML Frontmatter**: Populate strictly without `#` in values for Dataview reliability (e.g., `status: needs-triage`, `type: math-correction`).
- [x] **Content Formatting**: Structure note with Advisor Comment, Original Context, LaTeX Correction block, and Action Plan checklist.
- [x] **Raw Dump Backup**: Save the complete `feedback_dump.json` to `_infrastructure/raw_ai_dumps/` for auditability.

---

## 👁️ Phase 4: Human-in-the-Loop (HITL) Triage
*IA Action: Pause and await human review via the Obsidian Dashboard.*

- [ ] **Dashboard Rendered**: `_Dashboard.md` in `01_Feedback_Matrix/` is opened.
- [ ] **Human Review**: User reviews the Dataview table.
- [ ] **Status Updates**: User changes `status: needs-triage` to `status: clarified`, `status: rejected`, or `status: needs-clarification` based on accuracy.
- [ ] **Agenda Drafting**: User utilizes the "Needs Clarification" Dataview list to populate `03_Deliverables/PreEdit_Meeting_Agenda.md`.

---

## 🔄 Phase 5: Workflow Closure & Audit
*IA Action: Finalize the workflow state and prepare for the next chapter or iteration.*

- [ ] **Accuracy Assessment**: Human confirms extraction accuracy is acceptable (>85%).
- [ ] **Workflow Status Update**: Change `workflow_status` in YAML frontmatter to `completed`.
- [ ] **Archive**: Move processed PDF to `_infrastructure/raw_scans/archive/`.

---

## 📝 IA Execution Log
*This section is appended to by the IA process or human operator to track iterations, errors, and re-steering actions.*

| Timestamp | Phase | Action Taken | Result / Notes |
| :--- | :--- | :--- | :--- |
| *YYYY-MM-DD* | 0 | Initialized workflow | Dependencies verified. |
| | | | |
| | | | |
| 2026-06-15 13:00 | 0 | Environment Checked | Dependencies verified, active venv, target PDF exists. |
| 2026-06-15 13:00 | 1 | Image Extraction (DPI=300) | Extracted 28 pages as PNGs at 300 DPI. |
| 2026-06-16 14:36 | 0 | Environment Checked | Dependencies verified, active venv, target PDF exists. |
| 2026-06-16 14:36 | 1 | Image Extraction (DPI=300) | Extracted 28 pages as PNGs at 300 DPI. |
| 2026-06-16 14:59 | 2 | Vision AI Extraction | Processed 28 pages. Extracted a total of 68 comments (re-steered Page 3 at 400 DPI).
| 2026-06-16 14:59 | 3 | Ledger Generation | Generated 68 atomic notes in 01_Feedback_Matrix/ and backed up raw JSON.

---

> [!info] Instructions for the IA Process
> 1. Read the `workflow_status` and `current_phase` from the YAML frontmatter.
> 2. Execute the tasks for the `current_phase`.
> 3. If successful, check the boxes `[x]`, increment `current_phase`, and update the Execution Log.
> 4. If an error occurs, consult the **Re-steering Protocol** for that phase, apply the fix, log it, and retry before incrementing the phase.
> 5. Halt at Phase 4 and notify the human user: *"Phase 4 reached. Awaiting human triage in Obsidian Dataview dashboard."*

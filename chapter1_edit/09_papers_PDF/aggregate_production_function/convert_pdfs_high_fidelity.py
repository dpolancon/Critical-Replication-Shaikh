import os
import sys
import time
import requests
import pdfplumber
import traceback

def load_env(env_path):
    api_key = None
    api_base = "https://api.together.ai/v1"
    if os.path.exists(env_path):
        with open(env_path, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith("OPEN_API_KEY="):
                    api_key = line.split("=", 1)[1].strip()
                elif line.startswith("OPEN_API_BASE="):
                    api_base = line.split("=", 1)[1].strip()
    return api_key, api_base

def deduplicate_lines(text):
    if not text:
        return ""
    lines = text.split("\n")
    cleaned_lines = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            cleaned_lines.append(line)
            continue
        
        last_non_empty = None
        for prev in reversed(cleaned_lines):
            if prev.strip():
                last_non_empty = prev.strip()
                break
                
        if last_non_empty and stripped == last_non_empty:
            continue
            
        cleaned_lines.append(line)
    return "\n".join(cleaned_lines)

def process_page_with_llm(page_text, page_num, api_key, api_base):
    # Pre-cleaning
    deduped_text = deduplicate_lines(page_text)
    
    # If the text is very short, no need to send it to LLM
    if len(deduped_text.strip()) < 40:
        return deduped_text
        
    prompt = f"""You are an expert academic text formatter. Below is the raw, messy Markdown text extracted from page {page_num} of an academic paper.

Resolve the following layout and extraction issues:
1. Reconstruct the natural reading order. Academic papers are written in columns, so make sure text from separate columns is read down the column rather than horizontally merged across columns.
2. Formulate all mathematical equations, variables, and formulas in standard LaTeX markdown notation ($...$ for inline, $$...$$ for block). Ensure equations make mathematical sense and are not split across disjoint text lines.
3. Merge hyphenated words split at line endings (e.g. "pro- duction" -> "production").
4. Remove running page headers, footers, page numbers, and download watermarks (like JSTOR terms or IP address lines).

Maintain all original academic content, citations, footnotes, and prose exactly. Do not summarize or paraphrase. Return ONLY the cleaned Markdown text.
Do not repeat yourself under any circumstances. Once the text has been processed, stop writing.

Raw text:
{deduped_text}
"""

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": "Qwen/Qwen2.5-7B-Instruct-Turbo",
        "messages": [
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.2,
        "frequency_penalty": 0.5,
        "presence_penalty": 0.2,
        "max_tokens": 4096
    }
    
    max_retries = 3
    for attempt in range(max_retries):
        try:
            response = requests.post(f"{api_base}/chat/completions", headers=headers, json=data, timeout=45)
            if response.status_code == 200:
                result = response.json()
                return result["choices"][0]["message"]["content"].strip()
            elif response.status_code == 429:
                print(f"    Rate limit hit (429). Retrying in 5 seconds (attempt {attempt + 1}/{max_retries})...", flush=True)
                time.sleep(5)
            else:
                print(f"    API Error {response.status_code}: {response.text[:200]}", flush=True)
                time.sleep(2)
        except Exception as e:
            print(f"    Request exception: {e}", flush=True)
            time.sleep(2)
            
    # Fallback to deduplicated text if LLM call fails
    print("    Warning: LLM formatting failed after retries. Falling back to basic deduplicated text.", flush=True)
    return deduped_text

def convert_pdf_to_high_fidelity(pdf_path, md_path, api_key, api_base):
    print(f"\nProcessing: {os.path.basename(pdf_path)}", flush=True)
    print(f"Output target: {os.path.basename(md_path)}", flush=True)
    
    try:
        markdown_pages = []
        with pdfplumber.open(pdf_path) as pdf:
            total_pages = len(pdf.pages)
            print(f"  Total pages to convert: {total_pages}", flush=True)
            
            for i, page in enumerate(pdf.pages, 1):
                print(f"  - Converting page {i}/{total_pages}...", flush=True)
                raw_text = page.extract_text() or ""
                
                # Format page content using LLM
                cleaned_page_text = process_page_with_llm(raw_text, i, api_key, api_base)
                
                markdown_pages.append(f"\n## Page {i}\n\n{cleaned_page_text}")
                
                # Tiny delay to respect API rate limits
                time.sleep(0.2)
                
        # Join pages and write output
        full_markdown = "\n".join(markdown_pages).strip()
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(full_markdown)
        print(f"  Successfully saved clean Markdown: {os.path.basename(md_path)} ({len(full_markdown)} chars)", flush=True)
        
    except Exception as e:
        print(f"  Error converting PDF {pdf_path}: {e}", flush=True)
        traceback.print_exc()

def main():
    print("Unbuffered conversion script started.", flush=True)
    target_dir = r"C:\ReposGitHub\Critical-Replication-Shaikh\chapter1_edit\09_papers_PDF\aggregate_production_function"
    env_path = r"c:\ReposGitHub\academic-research-skills\.env"
    
    api_key, api_base = load_env(env_path)
    if not api_key:
        print("Error: Together API Key not found in academic-research-skills/.env", flush=True)
        sys.exit(1)
        
    pdf_files = [f for f in os.listdir(target_dir) if f.lower().endswith('.pdf')]
    if not pdf_files:
        print("No PDF files found.", flush=True)
        sys.exit(0)
        
    print(f"Found {len(pdf_files)} PDF papers to process in high-fidelity.", flush=True)
    
    for pdf_file in pdf_files:
        pdf_path = os.path.join(target_dir, pdf_file)
        md_file = os.path.splitext(pdf_file)[0] + ".md"
        md_path = os.path.join(target_dir, md_file)
        
        convert_pdf_to_high_fidelity(pdf_path, md_path, api_key, api_base)

if __name__ == '__main__':
    main()

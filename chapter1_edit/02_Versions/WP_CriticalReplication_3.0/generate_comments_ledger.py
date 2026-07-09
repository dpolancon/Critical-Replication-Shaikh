import os
import re

def parse_main_tex(filepath):
    paragraphs = []
    
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    current_id = None
    current_content_lines = []
    
    # Structural commands that end a paragraph block
    stop_patterns = [
        r'^\\paragraph\{',
        r'^\\section\{',
        r'^\\subsection\{',
        r'^\\subsubsection\{',
        r'^\\chapter\{',
        r'^\\input\{',
        r'^\\pagebreak',
        r'^\\clearpage',
        r'^\\begin\{table\}',
        r'^\\begin\{figure\}',
        r'^% ---------- Bibliography'
    ]
    
    compiled_stops = [re.compile(pat) for pat in stop_patterns]
    paragraph_pat = re.compile(r'^\\paragraph\{([0-9]+\.[0-9]+)\}')
    
    for line in lines:
        stripped = line.strip()
        
        # Check if we hit a paragraph start
        p_match = paragraph_pat.match(stripped)
        if p_match:
            # If we were already capturing, save the previous one
            if current_id is not None:
                paragraphs.append((current_id, current_content_lines))
            current_id = p_match.group(1)
            current_content_lines = []
            continue
            
        # Check if we hit any stop pattern
        hit_stop = False
        if current_id is not None:
            for pat in compiled_stops:
                if pat.match(stripped):
                    paragraphs.append((current_id, current_content_lines))
                    current_id = None
                    current_content_lines = []
                    hit_stop = True
                    break
            
            if hit_stop:
                continue
                
            # If we are currently capturing, append the line
            current_content_lines.append(line)
            
    # Append the last one if we finished the file
    if current_id is not None:
        paragraphs.append((current_id, current_content_lines))
        
    return paragraphs

def clean_paragraph_text(content_lines):
    cleaned_lines = []
    for line in content_lines:
        line_str = line.strip()
        # Skip comment lines
        if line_str.startswith('%'):
            continue
        cleaned_lines.append(line.rstrip('\r\n'))
        
    final_parts = []
    for line in cleaned_lines:
        stripped = line.strip()
        if not stripped:
            continue
        # Escape pipe characters for markdown table syntax
        stripped = stripped.replace('|', '\\|')
        final_parts.append(stripped)
        
    text = " ".join(final_parts)
    # Condense multiple spaces
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def main():
    tex_file = 'main.tex'
    comments_file = 'Comments.md'
    
    # Choose layout: 'stacked' (recommended for readability and wide editing margins) or 'table'
    LAYOUT = 'stacked' 
    
    if not os.path.exists(tex_file):
        print(f"Error: {tex_file} not found in current directory.")
        return
        
    paragraphs = parse_main_tex(tex_file)
    
    with open(comments_file, 'w', encoding='utf-8') as f:
        f.write("# Chapter 1 Master Editing Ledger\n\n")
        f.write("Use this ledger to lock finalized paragraphs, record observations/comments, and propose rewrites.\n\n")
        
        if LAYOUT == 'table':
            f.write("| Paragraph ID | Locked | Current Content | Observations or Comments | New Version |\n")
            f.write("|---|---|---|---|---|\n")
            for p_id, p_lines in paragraphs:
                cleaned_text = clean_paragraph_text(p_lines)
                if cleaned_text:
                    f.write(f"| {p_id} | [ ] | {cleaned_text} | | |\n")
        else: # stacked
            f.write("To lock a paragraph, check the box next to its ID (e.g., `- [x] Paragraph X.Y`).\n\n")
            for p_id, p_lines in paragraphs:
                cleaned_text = clean_paragraph_text(p_lines)
                if cleaned_text:
                    f.write(f"## Paragraph {p_id}\n")
                    f.write(f"- [ ] **Locked**\n\n")
                    f.write(f"**Current Content:**\n")
                    f.write(f"> {cleaned_text}\n\n")
                    f.write(f"**Observations or Comments:**\n")
                    f.write(f"*(Write observations here)*\n\n")
                    f.write(f"**New Version:**\n")
                    f.write(f"*(Draft new version here)*\n\n")
                    f.write(f"---\n\n")
                
    print(f"Successfully generated {comments_file} in '{LAYOUT}' layout with {len(paragraphs)} paragraphs.")

if __name__ == '__main__':
    main()

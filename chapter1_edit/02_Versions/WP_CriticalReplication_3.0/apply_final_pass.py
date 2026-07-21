import os
import re
import sys
import argparse

def parse_master_ledger(ledger_filepath):
    """
    Parses the master ledger (comments_final_pass.md) and extracts proposed new versions
    for unlocked paragraphs matching the Paragraph X.Y pattern.
    """
    if not os.path.exists(ledger_filepath):
        print(f"Error: Master ledger file not found at '{ledger_filepath}'")
        sys.exit(1)
        
    with open(ledger_filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Split by paragraph separators
    blocks = content.split('\n---\n')
    
    edits = {}
    
    # Regex to match Paragraph headers: e.g., '## Paragraph 1.1', '# Paragraph 1.3', '## Paragraph 2.11 (AI-isms)'
    p_header_pat = re.compile(r'^#+\s*Paragraph\s+(\d+)\.(\d+)', re.IGNORECASE | re.MULTILINE)
    # Regex to match Lock status: e.g., '- [x] **Locked**', '- [ ] Locked', etc.
    locked_pat = re.compile(r'-\s*\[\s*([xX\s])\s*\]\s*\*\*?Locked\*\*?', re.IGNORECASE)
    
    for block in blocks:
        block = block.strip()
        if not block:
            continue
            
        header_match = p_header_pat.search(block)
        if not header_match:
            continue
            
        sec_num = header_match.group(1)
        para_num = header_match.group(2)
        p_id = f"{sec_num}.{para_num}"
        
        # Check if locked
        locked = False
        l_match = locked_pat.search(block)
        if l_match and l_match.group(1) in ('x', 'X'):
            locked = True
            
        if locked:
            print(f"Skipping Paragraph {p_id} (Locked)")
            continue
            
        # Extract New Version content
        # New Version is located under **New Version:**
        idx = block.find('**New Version:**')
        if idx == -1:
            continue
            
        new_version_block = block[idx + len('**New Version:**'):].strip()
        
        # Clean default placeholder or empty content
        if not new_version_block or '*(Draft new version here)*' in new_version_block:
            continue
            
        # Clean blockquote markers
        clean_lines = []
        for line in new_version_block.split('\n'):
            line_strip = line.strip()
            if line_strip.startswith('>'):
                # Strip the leading '>' and optional space
                line = re.sub(r'^>\s*', '', line)
            clean_lines.append(line.rstrip())
        new_version_block = '\n'.join(clean_lines).strip()
        
        # Only save if we got actual content
        if new_version_block:
            if sec_num not in edits:
                edits[sec_num] = {}
            edits[sec_num][p_id] = new_version_block
            
    return edits

def apply_edits_to_tex(tex_filepath, section_edits, dry_run=True):
    """
    Applies extracted edits for a section to sectionX.tex by replacing the text of matching paragraphs.
    """
    if not os.path.exists(tex_filepath):
        print(f"Error: Target LaTeX file '{tex_filepath}' not found.")
        return False
        
    with open(tex_filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
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
    
    modified = False
    new_lines = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        
        # Check if this line starts a paragraph we have edits for
        p_match = re.match(r'^\\paragraph\{([0-9]+\.[0-9]+)\}', stripped)
        if p_match:
            p_id = p_match.group(1)
            if p_id in section_edits:
                new_lines.append(line) # Keep the \paragraph{X.Y} line itself
                
                # We skip lines in the original file until we hit a stop pattern
                i += 1
                original_text_lines = []
                hit_stop = False
                
                while i < len(lines):
                    next_stripped = lines[i].strip()
                    for pat in compiled_stops:
                        if pat.match(next_stripped):
                            hit_stop = True
                            break
                    if hit_stop:
                        # Append the proposed new version text, then the stop line (which will be processed normally)
                        original_text = "".join(original_text_lines).strip()
                        new_lines.append(section_edits[p_id] + "\n\n")
                        print(f"  [PENDING EDIT] Paragraph {p_id}:")
                        print(f"    - Original (first 80 chars): {original_text[:80]}...")
                        print(f"    - Replacement (first 80 chars): {section_edits[p_id][:80]}...")
                        break
                    original_text_lines.append(lines[i])
                    i += 1
                
                # In case we hit EOF before a stop pattern
                if not hit_stop:
                    new_lines.append(section_edits[p_id] + "\n\n")
                    print(f"  [PENDING EDIT] Paragraph {p_id} (EOF boundary):")
                    print(f"    - Replacement: {section_edits[p_id][:80]}...")
                    
                modified = True
                continue
                
        new_lines.append(line)
        i += 1
        
    if modified:
        if dry_run:
            print(f"  [DRY-RUN] Changes simulated for '{os.path.basename(tex_filepath)}'. No writes performed.")
            return True
        else:
            with open(tex_filepath, 'w', encoding='utf-8') as f:
                f.writelines(new_lines)
            print(f"  [APPLIED] Successfully updated '{os.path.basename(tex_filepath)}'.")
            return True
            
    return False

def main():
    parser = argparse.ArgumentParser(description="Apply master ledger edits from comments_final_pass.md to sectionX.tex files.")
    parser.add_argument('--apply', action='store_true', help="Execute the edits and write to the .tex files. (Defaults to dry-run mode).")
    parser.add_argument('--ledger', default='comments_final_pass.md', help="Path to the master ledger markdown file.")
    args = parser.parse_args()
    
    dry_run = not args.apply
    
    if dry_run:
        print("======================================================================")
        print("RUNNING IN DRY-RUN MODE. NO CHANGES WILL BE WRITTEN TO LATEX FILES.")
        print("To apply edits, run with the flag: python apply_final_pass.py --apply")
        print("======================================================================\n")
        
    print(f"Parsing master ledger: {args.ledger}")
    all_edits = parse_master_ledger(args.ledger)
    
    total_unlocked = sum(len(sec_edits) for sec_edits in all_edits.values())
    print(f"Found {total_unlocked} unlocked paragraphs with proposed edits across {len(all_edits)} sections.\n")
    
    for sec_num, section_edits in sorted(all_edits.items(), key=lambda x: int(x[0])):
        tex_file = f'section{sec_num}.tex'
        print(f"Processing Section {sec_num} ({tex_file}) with {len(section_edits)} edits:")
        
        if not os.path.exists(tex_file):
            print(f"  Warning: File '{tex_file}' does not exist in the current working directory. Skipping.")
            continue
            
        apply_edits_to_tex(tex_file, section_edits, dry_run=dry_run)
        print("")

if __name__ == '__main__':
    main()

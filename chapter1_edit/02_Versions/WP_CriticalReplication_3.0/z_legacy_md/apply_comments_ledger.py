import os
import re

def parse_comments_ledger(comments_filepath):
    """
    Parses Comments.md in stacked layout and extracts proposed new versions 
    for unlocked paragraphs.
    """
    with open(comments_filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Split by paragraph separators
    blocks = content.split('\n---\n')
    
    edits = {}
    
    # regex to match Paragraph header and Locked checkbox
    p_header_pat = re.compile(r'## Paragraph ([0-9]+\.[0-9]+)')
    locked_pat = re.compile(r'- \[(x| )\] \*\*Locked\*\*')
    
    for block in blocks:
        block = block.strip()
        if not block:
            continue
            
        header_match = p_header_pat.search(block)
        if not header_match:
            continue
            
        p_id = header_match.group(1)
        
        # Check if locked
        locked = False
        l_match = locked_pat.search(block)
        if l_match and l_match.group(1) == 'x':
            locked = True
            
        if locked:
            continue
            
        # Extract New Version content
        # New Version is located under **New Version:**
        idx = block.find('**New Version:**')
        if idx == -1:
            continue
            
        new_version_block = block[idx + len('**New Version:**'):].strip()
        
        # If it is empty, or placeholder, skip
        if not new_version_block or '*(Draft new version here)*' in new_version_block or '*(Draft new version here)*' == new_version_block.strip():
            continue
            
        edits[p_id] = new_version_block
        
    return edits

def apply_edits_to_tex(tex_filepath, edits):
    """
    Applies extracted edits to main.tex by replacing the text of matching paragraphs.
    """
    if not edits:
        print("No edits to apply.")
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
            if p_id in edits:
                new_lines.append(line) # Keep the \paragraph{X.Y} line itself
                
                # We skip lines until we hit a stop pattern
                i += 1
                while i < len(lines):
                    next_stripped = lines[i].strip()
                    hit_stop = False
                    for pat in compiled_stops:
                        if pat.match(next_stripped):
                            hit_stop = True
                            break
                    if hit_stop:
                        # Append the proposed new version text, then the stop line
                        new_lines.append(edits[p_id] + "\n\n")
                        print(f"Applied edit for Paragraph {p_id}")
                        break
                    i += 1
                
                modified = True
                continue
                
        new_lines.append(line)
        i += 1
        
    if modified:
        with open(tex_filepath, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        return True
    return False

def main():
    tex_file = 'main.tex'
    comments_file = 'Comments.md'
    
    if not os.path.exists(comments_file):
        print(f"Error: {comments_file} not found.")
        return
        
    if not os.path.exists(tex_file):
        print(f"Error: {tex_file} not found.")
        return
        
    edits = parse_comments_ledger(comments_file)
    print(f"Found {len(edits)} unlocked paragraphs with proposed edits: {list(edits.keys())}")
    
    if edits:
        success = apply_edits_to_tex(tex_file, edits)
        if success:
            print("Successfully updated main.tex with ledger edits.")
        else:
            print("No changes were written to main.tex.")

if __name__ == '__main__':
    main()

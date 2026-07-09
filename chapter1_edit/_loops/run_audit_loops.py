import os
import time
import openai
from dotenv import load_dotenv

# 1. Load environment variables
load_dotenv()
api_key = os.getenv("TOGETHER_API_KEY") or os.getenv("OPENAI_API_KEY") or os.getenv("OPEN_API_KEY")
api_base = os.getenv("OPEN_API_BASE", "https://api.together.ai/v1")

if not api_key:
    raise ValueError("Missing Together API Key in environment.")

client = openai.OpenAI(api_key=api_key, base_url=api_base)

# 2. Paths
base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
draft_path = os.path.join(base_dir, "03_NewVersion", "WP_CriticalReplication_2.0", "main.tex")
prompt_path = os.path.join(base_dir, "editing_artifacts", "ai_authorship_stress_test_ash_calibration.md")
output_dir = os.path.join(base_dir, "_loops", "stress_test_run_1")

os.makedirs(output_dir, exist_ok=True)

# 3. Read system instructions (prompt)
with open(prompt_path, "r", encoding="utf-8") as f:
    system_instructions = f.read()

# 4. Extract target sections from main.tex to keep context size tight and fit 8K models
with open(draft_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

def get_lines(start, end):
    # lines are 1-indexed in our manual verification
    return "".join(lines[start-1:end])

# Extracting critical connective tissue segments containing the style issues
target_text = "\n\n".join([
    "--- SEGMENT 1: INTRODUCTION ROADMAP ---\n" + get_lines(64, 110),
    "--- SEGMENT 2: STYLIZED DYNAMIC EXAMPLE ---\n" + get_lines(207, 235),
    "--- SEGMENT 3: STAGE S0 ARDL RECONSTRUCTION ---\n" + get_lines(520, 567),
    "--- SEGMENT 4: STAGE S1 STRESS TEST ---\n" + get_lines(568, 585),
    "--- SEGMENT 5: STAGE S2 VECM SYSTEM ---\n" + get_lines(680, 738),
    "--- SEGMENT 6: SECTION 5 CONCLUSION ---\n" + get_lines(762, 793)
])

# 5. Configurations to run (8 new reports)
configs = [
    {"model": "meta-llama/Llama-3.3-70B-Instruct-Turbo", "temp": 0.2, "filename": "report_2_llama3.3_70b_temp0.2.md"},
    {"model": "meta-llama/Llama-3.3-70B-Instruct-Turbo", "temp": 0.7, "filename": "report_3_llama3.3_70b_temp0.7.md"},
    {"model": "Qwen/Qwen2.5-7B-Instruct-Turbo", "temp": 0.2, "filename": "report_4_qwen2.5_7b_temp0.2.md"},
    {"model": "Qwen/Qwen2.5-7B-Instruct-Turbo", "temp": 0.7, "filename": "report_5_qwen2.5_7b_temp0.7.md"},
    {"model": "Qwen/Qwen3-235B-A22B-Instruct-2507-FP8", "temp": 0.2, "filename": "report_6_qwen3_235b_fp8.md"},
    {"model": "Qwen/Qwen3-235B-A22B-Instruct-2507-tput", "temp": 0.2, "filename": "report_7_qwen3_235b_tput.md"},
    {"model": "meta-llama/Meta-Llama-3-8B-Instruct-Lite", "temp": 0.2, "filename": "report_8_llama3_8b_lite.md"},
    {"model": "arize-ai/qwen-2-1.5b-instruct", "temp": 0.2, "filename": "report_9_qwen2_1.5b.md"}
]

print("Starting Loop to Generate 8 AI-Authorship Stress Test Reports...")
print(f"Target text size: {len(target_text)} characters (~{len(target_text)//4} tokens)")

for i, cfg in enumerate(configs, start=2):
    model = cfg["model"]
    temp = cfg["temp"]
    filename = cfg["filename"]
    filepath = os.path.join(output_dir, filename)
    
    print(f"\n[{i}/9] Running model {model} (temp={temp}) -> {filename}...")
    
    # Retry logic up to 3 times
    success = False
    for attempt in range(1, 4):
        try:
            response = client.chat.completions.create(
                model=model,
                messages=[
                    {"role": "system", "content": system_instructions},
                    {"role": "user", "content": f"Please execute the stylometric audit on the following LaTeX draft text. Run /calibrate, /diagnose, and output the /report using the locked flag-report format.\n\nTARGET TEXT:\n{target_text}"}
                ],
                temperature=temp,
                max_tokens=4096
            )
            report_content = response.choices[0].message.content
            
            with open(filepath, "w", encoding="utf-8") as out_f:
                out_f.write(report_content)
                
            print(f"  [SUCCESS] Written to {filepath}")
            success = True
            break
        except Exception as e:
            print(f"  [ERROR] Attempt {attempt} failed: {e}")
            time.sleep(3)
            
    if not success:
        print(f"  [FAILED] Could not generate report for {model} after 3 attempts.")

print("\nLoop execution complete.")

import os
import argparse
from dotenv import load_dotenv
from openai import OpenAI

# Cargar variables de entorno desde el archivo .env
load_dotenv()

def main():
    api_key = os.getenv("TOGETHER_API_KEY")
    if not api_key:
        print("❌ Error: No se encontró TOGETHER_API_KEY en el archivo .env o en el entorno")
        return

    client = OpenAI(
        api_key=api_key,
        base_url="https://api.together.xyz/v1",
    )

    parser = argparse.ArgumentParser(description="Asistente de investigación Qwen vía Together.ai")
    parser.add_argument("prompt", type=str, help="La pregunta o instrucción para Qwen")
    parser.add_argument("--model", type=str, default="Qwen/Qwen3.5-9B", help="Modelo de Qwen a utilizar")
    parser.add_argument("--system", type=str, default="Eres un asistente de investigación académica experto en economía heterodoxa, ciencia de datos, macroeconomía y metodología rigurosa. Responde de forma estructurada, cita fuentes cuando sea posible y mantén un tono académico.", help="Prompt del sistema para contextualizar")
    
    args = parser.parse_args()

    print(f"🔄 Consultando a {args.model}...\n" + "="*60)

    try:
        is_streaming_model = any(term in args.model for term in ["3.7", "Max", "Plus"])
        if is_streaming_model:
            response = client.chat.completions.create(
                model=args.model,
                messages=[
                    {"role": "system", "content": args.system},
                    {"role": "user", "content": args.prompt}
                ],
                temperature=0.2,
                max_tokens=4000,
                stream=True
            )
            for chunk in response:
                if chunk.choices and chunk.choices[0].delta.content:
                    print(chunk.choices[0].delta.content, end="", flush=True)
            print()
        else:
            response = client.chat.completions.create(
                model=args.model,
                messages=[
                    {"role": "system", "content": args.system},
                    {"role": "user", "content": args.prompt}
                ],
                temperature=0.2,
                max_tokens=4000,
            )
            print(response.choices[0].message.content)
        print("\n" + "="*60)
    except Exception as e:
        print(f"❌ Error al consultar la API: {e}")

if __name__ == "__main__":
    main()

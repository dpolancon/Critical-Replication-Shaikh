import os
import time
import logging
from openai import OpenAI

logger = logging.getLogger(__name__)

class TogetherAIClient:
    """Wrapper class for Together.ai API interactions supporting text and vision models."""
    
    def __init__(self, base_url: str = "https://api.together.xyz/v1", api_key: str = None):
        if api_key is None:
            api_key = os.getenv("TOGETHER_API_KEY")
            if not api_key:
                raise ValueError("API key must be provided or set in TOGETHER_API_KEY environment variable")
        
        self.client = OpenAI(
            base_url=base_url,
            api_key=api_key,
        )
    
    def query_llm(self, prompt_text: str, model: str = "Qwen/Qwen3.5-9B", max_retries: int = 3) -> str:
        """Send a prompt to the LLM and return the response."""
        is_streaming_model = any(term in model for term in ["3.7", "Max", "Plus"])
        for attempt in range(max_retries):
            try:
                if is_streaming_model:
                    response = self.client.chat.completions.create(
                        model=model,
                        messages=[
                            {"role": "user", "content": prompt_text}
                        ],
                        temperature=0.1,
                        max_tokens=4000,
                        stream=True
                    )
                    full_content = ""
                    for chunk in response:
                        if chunk.choices and chunk.choices[0].delta.content:
                            full_content += chunk.choices[0].delta.content
                    return full_content.strip()
                else:
                    response = self.client.chat.completions.create(
                        model=model,
                        messages=[
                            {"role": "user", "content": prompt_text}
                        ],
                        temperature=0.1,
                        max_tokens=4000,
                    )
                    return response.choices[0].message.content.strip()
            
            except Exception as e:
                if "rate limit" in str(e).lower() and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2, 5, 9 seconds
                    logger.warning(f"Rate limit hit. Waiting {wait_time} seconds before retry {attempt + 1}/{max_retries}")
                    time.sleep(wait_time)
                else:
                    logger.error(f"API call failed after {attempt + 1} attempts: {e}")
                    raise e
        
        raise Exception("Max retries exceeded")

    def query_vision_llm(self, prompt_text: str, base64_image: str, model: str = "Qwen/Qwen3.7-Plus", max_tokens: int = 4000, max_retries: int = 3) -> str:
        """Send a prompt with a base64-encoded image to the vision LLM and return the response."""
        is_streaming_model = any(term in model for term in ["3.7", "Max", "Plus"])
        for attempt in range(max_retries):
            try:
                if is_streaming_model:
                    response = self.client.chat.completions.create(
                        model=model,
                        messages=[
                            {
                                "role": "user",
                                "content": [
                                    {"type": "text", "text": prompt_text},
                                    {
                                        "type": "image_url",
                                        "image_url": {
                                            "url": f"data:image/png;base64,{base64_image}"
                                        }
                                    }
                                ]
                            }
                        ],
                        temperature=0.1,
                        max_tokens=max_tokens,
                        stream=True
                    )
                    full_content = ""
                    for chunk in response:
                        if chunk.choices and chunk.choices[0].delta.content:
                            full_content += chunk.choices[0].delta.content
                    return full_content.strip()
                else:
                    response = self.client.chat.completions.create(
                        model=model,
                        messages=[
                            {
                                "role": "user",
                                "content": [
                                    {"type": "text", "text": prompt_text},
                                    {
                                        "type": "image_url",
                                        "image_url": {
                                            "url": f"data:image/png;base64,{base64_image}"
                                        }
                                    }
                                ]
                            }
                        ],
                        temperature=0.1,
                        max_tokens=max_tokens,
                    )
                    return response.choices[0].message.content.strip()
            
            except Exception as e:
                if "rate limit" in str(e).lower() and attempt < max_retries - 1:
                    wait_time = (2 ** attempt) + 1  # 2, 5, 9 seconds
                    logger.warning(f"Rate limit hit. Waiting {wait_time} seconds before retry {attempt + 1}/{max_retries}")
                    time.sleep(wait_time)
                else:
                    logger.error(f"API call failed after {attempt + 1} attempts: {e}")
                    raise e
        
        raise Exception("Max retries exceeded")

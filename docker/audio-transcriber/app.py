import os
import tempfile
from functools import lru_cache

from fastapi import FastAPI, File, Form, HTTPException, UploadFile
from faster_whisper import WhisperModel


app = FastAPI(title="Financeiro Audio Transcriber")


@lru_cache(maxsize=1)
def get_model() -> WhisperModel:
    model_size = os.getenv("WHISPER_MODEL_SIZE", "small")
    device = os.getenv("WHISPER_DEVICE", "cpu")
    compute_type = os.getenv("WHISPER_COMPUTE_TYPE", "int8")

    return WhisperModel(model_size, device=device, compute_type=compute_type)


@app.get("/up")
def up() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/v1/audio/transcriptions")
async def transcribe_audio(
    file: UploadFile = File(...),
    model: str = Form(default="whisper-1"),
    language: str = Form(default="pt"),
    response_format: str = Form(default="json"),
) -> dict[str, str]:
    if response_format != "json":
        raise HTTPException(status_code=400, detail="Only json response_format is supported.")

    suffix = os.path.splitext(file.filename or "audio.bin")[1] or ".bin"

    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp_file:
        temp_path = temp_file.name
        temp_file.write(await file.read())

    try:
        segments, _info = get_model().transcribe(
            temp_path,
            language=language or "pt",
            vad_filter=True,
        )
        text = " ".join(segment.text.strip() for segment in segments).strip()
        return {"text": text, "model": model}
    finally:
        try:
            os.unlink(temp_path)
        except FileNotFoundError:
            pass

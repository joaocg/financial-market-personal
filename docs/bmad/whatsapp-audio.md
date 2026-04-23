# WhatsApp Audio

## Estado atual

- O Laravel distingue imagem de audio.
- Audio nao entra mais no fluxo de comprovante.
- Quando habilitada, a transcricao alimenta o mesmo pipeline de texto e IA do WhatsApp.

## Flags

```env
WHATSAPP_AUDIO_TRANSCRIPTION_ENABLED=true
WHATSAPP_AUDIO_TRANSCRIPTION_PROVIDER=http
WHATSAPP_AUDIO_TRANSCRIPTION_BASE_URL=http://audio-transcriber:8001
WHATSAPP_AUDIO_TRANSCRIPTION_ENDPOINT=/v1/audio/transcriptions
WHATSAPP_AUDIO_TRANSCRIPTION_MODEL=whisper-1
WHATSAPP_AUDIO_TRANSCRIPTION_LANGUAGE=pt
WHATSAPP_AUDIO_TRANSCRIPTION_TIMEOUT=120
```

## Subir o transcritor opcional

```bash
docker compose --profile audio up -d audio-transcriber
docker compose up -d app worker
```

## Observacoes

- Se preferir rodar o transcritor no host, mantenha `WHATSAPP_AUDIO_TRANSCRIPTION_PROVIDER=http`
  e aponte `WHATSAPP_AUDIO_TRANSCRIPTION_BASE_URL` para `http://host.docker.internal:8001`.
- O endpoint exposto pelo servico opcional e compativel com `/v1/audio/transcriptions`.
- O recurso continua desligado por padrao.

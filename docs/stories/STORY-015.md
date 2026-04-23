# Ingestao inicial de imagem para assistencia por IA com OCR-first

- **ID:** STORY-015
- **Epic:** Assistencia inteligente
- **Priority:** Should Have
- **Story Points:** 8
- **Status:** Completed

## User Story

As a **membro operacional da familia**
I want to **enviar um comprovante de imagem e receber uma sugestao de lancamento**
So that **eu registre uma movimentacao com menos digitacao e menor atrito**

## Acceptance Criteria

- [x] **Criterion 1:** O sistema aceita uma imagem de comprovante enviada pelo fluxo conversacional e registra uma solicitacao de analise assíncrona.
- [x] **Criterion 2:** O pipeline executa OCR local para extrair texto da imagem antes de considerar qualquer fallback de IA.
- [x] **Criterion 3:** O sistema tenta sugerir `tipo`, `valor`, `data` e `descricao` com base no texto OCR usando parser heuristico.
- [x] **Criterion 4:** O fallback de IA so e acionado quando a confianca do OCR/parser ficar abaixo do limiar configurado.
- [x] **Criterion 5:** A sugestao final e devolvida ao usuario com confirmacao humana obrigatoria antes de qualquer gravacao.

## Technical Notes

### Implementation Approach

Implementar um pipeline `OCR first, IA fallback` dentro do modulo de assistencia inteligente. O processamento deve ser assíncrono, com separacao clara entre:

- recebimento da imagem
- OCR
- classificacao heuristica
- fallback opcional de IA
- montagem da sugestao para confirmacao

### Files/Modules Affected

- `laravel/app/Modules/AI/` ou equivalente do modulo de assistencia
- `laravel/app/Modules/Messaging/` para integrar com o fluxo conversacional
- `laravel/app/Modules/Shared/` para storage e utilitarios de parsing, se necessario
- migrations para requests/results de analise, se ainda nao existirem
- documentacao operacional de dependencias OCR

### Data Model Changes

- tabela `ai_analysis_requests`
- tabela `ai_analysis_results`
- referencia de midia processada vinculada ao evento de mensagem ou contexto conversacional

### API Changes

- nao exige endpoint publico novo obrigatorio
- pode exigir action/job interna para enfileirar e consultar status da analise

### Edge Cases

- **Imagem ilegivel:** responder com falha segura e orientar lancamento manual.
- **OCR parcial:** continuar com parser heuristico e marcar baixa confianca.
- **Classificacao ambigua:** usar fallback de IA ou retornar `desconhecido` para confirmacao manual.

### Performance Considerations

O webhook nao deve bloquear esperando OCR. Todo processamento pesado deve ocorrer em worker.

### Security Considerations

- restringir acesso por familia e membro
- evitar exposicao de imagem e texto bruto em logs
- manter confirmacao humana obrigatoria antes da persistencia

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-011` - fluxo guiado de despesa precisa existir para reaproveitar confirmacao
- **Blocked by:** `STORY-012` - fluxo guiado de credito precisa existir para reaproveitar confirmacao
- **Blocked by:** `STORY-019` - smoke test conversacional concluido reduz risco da integracao
- **Blocks:** nenhuma historia obrigatoria imediata, mas prepara evolucoes de IA mais sofisticadas

### Technical Dependencies

- storage de midia funcional
- worker Laravel operacional
- engine OCR disponivel no ambiente
- provider de IA externo opcional para fallback

### Open Questions

- [x] A primeira iteracao suportara apenas imagens recebidas no WhatsApp ou tambem upload no frontend?
- [x] O target inicial de OCR sera `Tesseract` pela simplicidade ou `PaddleOCR` pela qualidade?

## Testing Requirements

### Unit Tests

- [x] Validar parser heuristico de valor, data e tipo
- [x] Validar score de confianca
- [x] Validar regra que decide se o fallback de IA sera acionado

### Integration Tests

- [x] Processar comprovante de pagamento sem usar IA
- [x] Processar comprovante de deposito sem usar IA
- [x] Processar comprovante ambiguo com fallback de IA

### Manual Testing

- [x] Enviar imagem de comprovante legivel
- [x] Confirmar sugestao de campos retornada no fluxo conversacional
- [x] Validar que um comprovante ruim nao gera gravacao automatica

## Definition of Done

This story is considered complete when:

- [x] Code is written and follows project coding standards
- [x] All acceptance criteria are met and verified
- [x] Unit tests are written and passing (>80% coverage for new code)
- [x] Integration tests are written and passing (if applicable)
- [x] Code has been reviewed and approved by at least one team member
- [x] No critical or high-priority bugs remain
- [x] Documentation is updated (README, API docs, inline comments)
- [x] Changes are merged to main/development branch
- [x] Deployed to local development environment
- [x] Product owner has reviewed and accepted the story

## Notes

Esta historia deve permanecer limitada ao menor corte util do problema: ler comprovantes comuns, sugerir campos com custo baixo e depender de IA apenas quando a heuristica nao for suficiente.

## Delivery Notes

- O webhook do WhatsApp agora reconhece imagens de comprovante, cria uma solicitacao assíncrona em `ai_analysis_requests` e responde com um ack imediato.
- O worker executa OCR local primeiro, aplica heuristica para tipo, valor, data e descricao, e so aciona fallback de IA abaixo do limiar configurado.
- O resultado final sempre exige confirmacao humana antes de qualquer lancamento contábil.
- A documentacao operacional foi atualizada com o fluxo de ingesta, smoke check e diagnosticos principais.

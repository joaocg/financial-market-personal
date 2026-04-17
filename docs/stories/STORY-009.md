# Receber webhook WAHA com idempotencia e autorizacao de membro

- **ID:** STORY-009
- **Epic:** WhatsApp operacional inicial
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **sistema**
I want to **receber eventos do WAHA com seguranca e resolver o membro autorizado**
So that **o canal WhatsApp possa iniciar fluxos validos sem duplicidade nem acesso indevido**

## Acceptance Criteria

- [x] **Criterion 1:** Existe endpoint de webhook para eventos WAHA no backend Laravel.
- [x] **Criterion 2:** O endpoint valida segredo compartilhado ou mecanismo equivalente de autenticacao.
- [x] **Criterion 3:** Eventos recebidos sao persistidos de forma bruta para auditoria e reprocessamento.
- [x] **Criterion 4:** O processamento garante idempotencia por identificador externo do evento ou mensagem.
- [x] **Criterion 5:** O backend resolve o contato recebido para um membro ativo e marca eventos nao autorizados quando nao houver vinculo valido.

## Technical Notes

### Implementation Approach

Implementar o primeiro fluxo do modulo `Messaging` com controller de webhook, DTO de entrada, persistencia do evento bruto e camada de resolucao de remetente contra contatos cadastrados da familia. O processamento pode ser inicialmente sincrono na parte de persistencia e assíncrono para fluxos futuros.

### Files/Modules Affected

- `laravel/app/Modules/Messaging/` - webhook, actions, modelos e regras de idempotencia
- `laravel/app/Modules/Families/` - consulta de contatos autorizados
- `laravel/database/migrations/` - tabelas de eventos/mensagens ou sessoes minimas
- `laravel/tests/Feature/Messaging/` - testes do webhook WAHA

### Data Model Changes

- criar tabela `message_events` com `external_message_id`, `family_id`, `membership_id`, `payload`, `processing_status`, `received_at`
- adicionar indice unico em `external_message_id` ou combinacao equivalente
- opcionalmente criar tabela de `conversation_sessions` vazia para evolucao futura

### API Changes

- `POST /api/v1/webhooks/waha`
- autenticacao por segredo de webhook, nao por JWT

### Edge Cases

- **Evento duplicado:** deve ser reconhecido e nao gerar duplicidade operacional.
- **Remetente nao autorizado:** persistir evento com status apropriado sem iniciar fluxo de negocio.
- **Payload incompleto do WAHA:** responder de forma defensiva e registrar falha de validacao.

### Performance Considerations

O endpoint deve responder rapido, preferencialmente com `202 Accepted`, deixando qualquer logica mais pesada para fila ou processamento posterior.

### Security Considerations

- validar segredo do webhook antes do processamento
- normalizar telefone de origem antes da resolucao do membro
- evitar executar qualquer fluxo financeiro para remetente sem vinculo ativo

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-004` - e necessario ter familias, membros e contatos basicos cadastrados
- **Blocks:** `STORY-010` - consulta de saldo via WhatsApp depende da entrada segura de eventos

### Technical Dependencies

- WAHA local configurado e acessivel
- segredo de webhook definido em ambiente
- contatos de membros persistidos no modulo `Families`

### Open Questions

- [ ] Qual header ou formato exato sera usado para validar o segredo do webhook do WAHA?
- [ ] O endpoint inicial respondera `200` ou `202` apos persistir o evento?

## Testing Requirements

### Unit Tests

- [x] Validar normalizacao do telefone de origem
- [x] Validar reconhecimento de evento duplicado
- [x] Validar resolucao de contato autorizado

### Integration Tests

- [x] Enviar webhook valido e confirmar persistencia do evento bruto
- [x] Enviar webhook duplicado e confirmar comportamento idempotente
- [x] Enviar webhook sem autenticacao valida e receber erro apropriado

### Manual Testing

- [x] Simular mensagem de contato autorizado
- [x] Simular mensagem de contato nao autorizado
- [x] Inspecionar payload persistido para reprocessamento futuro

## Definition of Done

This story is considered complete when:

- [ ] Code is written and follows project coding standards
- [ ] All acceptance criteria are met and verified
- [ ] Unit tests are written and passing (>80% coverage for new code)
- [ ] Integration tests are written and passing (if applicable)
- [ ] Code has been reviewed and approved by at least one team member
- [ ] No critical or high-priority bugs remain
- [ ] Documentation is updated (README, API docs, inline comments)
- [ ] Changes are merged to main/development branch
- [ ] Deployed to local development environment
- [ ] Product owner has reviewed and accepted the story

## Notes

Esta historia entrega a base de `FR-009` e prepara o terreno para `FR-011`, mantendo o WAHA estritamente como camada de transporte.

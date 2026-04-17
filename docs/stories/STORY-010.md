# Entregar consulta de saldo via WhatsApp

- **ID:** STORY-010
- **Epic:** WhatsApp operacional inicial
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Not Started

## User Story

As a **membro autorizado**
I want to **consultar meu saldo pelo WhatsApp**
So that **eu obtenha uma resposta rapida sem precisar abrir o painel web**

## Acceptance Criteria

- [ ] **Criterion 1:** O sistema interpreta a intencao basica de consulta de saldo a partir do evento recebido pelo webhook.
- [ ] **Criterion 2:** O sistema resolve o idioma e o contexto do membro autenticado pelo contato.
- [ ] **Criterion 3:** O backend consulta o saldo consolidado ou por conta usando o contrato criado em `STORY-007`.
- [ ] **Criterion 4:** O sistema responde pelo fluxo de mensagens com texto simples e informacao de referencia temporal.
- [ ] **Criterion 5:** Eventos nao autorizados, ambiguos ou sem saldo disponivel retornam resposta segura e controlada.

## Technical Notes

### Implementation Approach

Criar o primeiro caso de uso funcional do modulo `Messaging`, com parser de intencao limitado a consulta de saldo, integração com o query service de `Ledger` e adaptador de envio ao WAHA. O fluxo deve ser deliberadamente simples, sem NLP sofisticado.

### Files/Modules Affected

- `laravel/app/Modules/Messaging/` - parser de intencao, action de saldo e adaptador de resposta
- `laravel/app/Modules/Ledger/` - reuso do endpoint ou query service de saldo
- `laravel/app/Modules/Families/` - leitura de idioma e membership
- `laravel/tests/Feature/Messaging/` - testes do fluxo de saldo via WhatsApp

### Data Model Changes

- pode reutilizar `message_events`
- opcionalmente registrar tabela simples de `message_outbox` para auditoria de resposta enviada

### API Changes

- sem nova rota publica alem do webhook ja criado
- integracao interna com cliente WAHA para envio da resposta

### Edge Cases

- **Texto ambiguo:** responder com mensagem curta pedindo comando mais claro.
- **Membro sem conta configurada:** responder com orientacao segura sem quebrar o fluxo.
- **Falha no envio ao WAHA:** registrar tentativa para diagnostico e retentativa futura.

### Performance Considerations

O fluxo deve reaproveitar o resumo de saldo existente e evitar qualquer computacao pesada no ciclo de resposta da mensagem.

### Security Considerations

- responder apenas para membros autorizados
- nao expor dados financeiros de outra familia por erro de resolucao de contexto
- sanitizar payload de saida e logs associados

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-007` - consulta de saldo precisa existir como capacidade do backend
- **Blocked by:** `STORY-009` - o webhook WAHA e a resolucao do membro precisam estar funcionais
- **Blocks:** nenhuma historia direta desta sprint

### Technical Dependencies

- cliente ou adaptador WAHA para envio de mensagens
- query service de saldo reutilizavel no modulo `Ledger`
- idioma e contatos dos membros disponiveis

### Open Questions

- [ ] Qual conjunto minimo de frases ou comandos sera aceito para detectar a intencao de saldo?
- [ ] A primeira resposta retornara apenas saldo consolidado ou tambem a lista resumida de contas?

## Testing Requirements

### Unit Tests

- [ ] Validar parser de intencao para consulta de saldo
- [ ] Validar composicao da mensagem de resposta
- [ ] Validar tratamento de membro nao autorizado

### Integration Tests

- [ ] Receber webhook com intencao de saldo e disparar resposta correta
- [ ] Consultar saldo de membro autorizado com familia valida
- [ ] Receber mensagem invalida ou ambigua e retornar resposta controlada

### Manual Testing

- [ ] Enviar mensagem de saldo a partir de contato autorizado
- [ ] Validar idioma e contexto da resposta
- [ ] Conferir comportamento quando nao houver contas ou movimentacoes

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

Esta historia materializa `FR-011` e entrega o primeiro fluxo conversacional realmente utilizavel do MVP, com parser intencionalmente restrito para reduzir ambiguidade.

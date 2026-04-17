# Fluxo guiado de registro de despesa via WhatsApp

- **ID:** STORY-011
- **Epic:** Fluxo guiado WhatsApp
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Not Started

## User Story

As a **membro autorizado**
I want to **registrar uma despesa por um fluxo guiado no WhatsApp**
So that **eu consiga lancar gastos sem abrir o painel web**

## Acceptance Criteria

- [ ] **Criterion 1:** O sistema identifica a intencao de registrar despesa a partir do evento recebido pelo webhook.
- [ ] **Criterion 2:** O fluxo solicita os dados minimos da despesa antes de persistir qualquer lancamento.
- [ ] **Criterion 3:** O sistema confirma valor, descricao e conta antes de concluir o registro.
- [ ] **Criterion 4:** O lancamento eh persistido com impacto correto no saldo da conta e da familia.
- [ ] **Criterion 5:** Respostas para entradas invalidas, incompletas ou nao autorizadas sao seguras e controladas.

## Technical Notes

### Implementation Approach

Criar um fluxo conversacional simples e deterministico no modulo de mensagens, reaproveitando o webhook WAHA e o motor de lancamentos ja entregue. O objetivo e guiar o usuario ate a confirmacao final, sem NLP sofisticado e sem pular a etapa de validacao.

### Files/Modules Affected

- `laravel/app/Modules/Messaging/` - orquestracao do fluxo guiado, estados da conversa e respostas ao usuario
- `laravel/app/Modules/Ledger/` - criacao do lancamento de despesa e atualizacao de saldo
- `laravel/app/Modules/Families/` - resolucao de contexto do membro autorizado e conta associada
- `laravel/tests/Feature/Messaging/` - testes do fluxo guiado de despesa

### Data Model Changes

- pode ser necessario registrar estado transitorio da conversa para acompanhar a coleta dos campos
- o lancamento final deve continuar usando o modelo existente de ledger

### API Changes

- sem nova rota publica
- o webhook atual passa a suportar etapas intermediarias do fluxo de confirmacao

### Edge Cases

- **Mensagem ambigua:** responder com uma pergunta curta e orientar o proximo passo.
- **Dados incompletos:** manter o estado da conversa e solicitar o campo faltante.
- **Duplicidade de confirmacao:** evitar lancar a mesma despesa mais de uma vez.

### Performance Considerations

O fluxo deve manter baixa latencia, porque a interacao depende de resposta rapida no WhatsApp. O estado transitorio precisa ser simples e consultado sem custo elevado.

### Security Considerations

- permitir o fluxo apenas para membros autorizados
- validar valores numericos e campos textuais antes de persistir
- evitar exposicao de saldo ou dados de outra familia durante a conversa

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-009` - webhook WAHA e autorizacao de membro precisam existir
- **Blocked by:** `STORY-006` - o sistema precisa conseguir registrar despesas no ledger
- **Blocks:** `STORY-012` - o mesmo padrao de fluxo guiado pode ser reaproveitado para creditos

### Technical Dependencies

- webhook WAHA operacional
- endpoint ou service de criacao de lancamentos do ledger
- persistencia de estado transitorio da conversa, se ainda nao existir

### Open Questions

- [ ] Qual e a ordem exata dos campos na coleta guiada da despesa?
- [ ] O usuario podera escolher a conta antes da confirmacao final?

## Testing Requirements

### Unit Tests

- [ ] Validar deteccao da intencao de despesa
- [ ] Validar transicoes de estado do fluxo guiado
- [ ] Validar montagem da mensagem de confirmacao

### Integration Tests

- [ ] Receber mensagem inicial de despesa e seguir para coleta guiada
- [ ] Confirmar uma despesa e verificar o impacto no saldo

### Manual Testing

- [ ] Enviar uma mensagem de despesa a partir de contato autorizado
- [ ] Confirmar a despesa e verificar a persistencia final

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

Primeira parte do fluxo guiado do WhatsApp para lancamentos. O foco e reduzir friccao sem comprometer a validacao do ledger.


# Fluxo guiado de registro de credito via WhatsApp

- **ID:** STORY-012
- **Epic:** Fluxo guiado WhatsApp
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Not Started

## User Story

As a **membro autorizado**
I want to **registrar um credito por um fluxo guiado no WhatsApp**
So that **eu consiga lancar entradas financeiras sem usar o painel web**

## Acceptance Criteria

- [ ] **Criterion 1:** O sistema reconhece a intencao de registrar credito no fluxo de mensagens.
- [ ] **Criterion 2:** O usuario informa os dados minimos do credito em etapas guiadas.
- [ ] **Criterion 3:** O sistema pede confirmacao antes de efetivar o lancamento.
- [ ] **Criterion 4:** O credito e persistido com atualizacao correta do saldo.
- [ ] **Criterion 5:** Erros de validacao, ambiguidade ou falta de autorizacao sao tratados sem expor dados indevidos.

## Technical Notes

### Implementation Approach

Reutilizar a mesma maquina de estados do fluxo de despesa, mas com tipo de lancamento invertido e mensagens ajustadas para credito. A historia deve manter o comportamento previsivel e aproveitar as mesmas integracoes internas.

### Files/Modules Affected

- `laravel/app/Modules/Messaging/` - fluxo guiado de credito e composicao de respostas
- `laravel/app/Modules/Ledger/` - criacao do lancamento de credito e recalculo de saldo
- `laravel/app/Modules/Families/` - contexto do membro e da familia
- `laravel/tests/Feature/Messaging/` - testes do fluxo de credito

### Data Model Changes

- sem novas tabelas obrigatorias se o estado da conversa puder ser reaproveitado
- o ledger deve registrar o lancamento usando o mesmo modelo transacional existente

### API Changes

- sem nova rota publica
- o webhook atual deve aceitar a trilha de interacoes necessaria para confirmacao

### Edge Cases

- **Valor zero ou negativo:** rejeitar com mensagem clara.
- **Descricao vazia:** solicitar complemento antes de seguir.
- **Retorno duplicado do WhatsApp:** impedir criacao repetida do mesmo lancamento.

### Performance Considerations

O fluxo deve ser leve e responder em poucas interacoes, porque a experiencia no WhatsApp depende de conversacao fluida.

### Security Considerations

- validar autorizacao do membro antes de iniciar o fluxo
- evitar vazamento de informacoes financeiras durante mensagens de erro
- registrar apenas o necessario para auditoria e diagnostico

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-009` - webhook WAHA e resolucao do membro precisam existir
- **Blocked by:** `STORY-006` - o ledger precisa suportar lancamentos manuais
- **Blocks:** nenhuma historia direta nesta sprint

### Technical Dependencies

- webhook WAHA operacional
- service de ledger para lancamento de credito
- persistencia do contexto da conversa, se necessario

### Open Questions

- [ ] O fluxo de credito deve solicitar conta de destino ou assumir a conta padrao da familia?
- [ ] Ha alguma diferenca de linguagem ou copy entre credito e despesa?

## Testing Requirements

### Unit Tests

- [ ] Validar deteccao da intencao de credito
- [ ] Validar confirmacao antes da persistencia
- [ ] Validar tratamento de valores invalidos

### Integration Tests

- [ ] Executar o fluxo completo de credito ate a persistencia
- [ ] Validar o comportamento para evento duplicado

### Manual Testing

- [ ] Registrar um credito via WhatsApp em ambiente local
- [ ] Confirmar que o saldo foi atualizado corretamente

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

Esta historia fecha o par de fluxos conversacionais basicos do MVP financeiro no WhatsApp.

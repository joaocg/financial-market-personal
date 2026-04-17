# Smoke test ponta a ponta do fluxo WAHA ate o ledger

- **ID:** STORY-019
- **Epic:** Operacao WAHA e onboarding conversacional
- **Priority:** Should Have
- **Story Points:** 3
- **Status:** Draft

## User Story

As a **responsavel por validar o MVP**
I want to **executar um smoke test ponta a ponta do WAHA ate o ledger**
So that **eu confirme que o canal conversacional esta operacional de verdade**

## Acceptance Criteria

- [ ] **Criterion 1:** Existe um roteiro objetivo para validar recebimento de mensagem, resolucao do membro, fluxo guiado e persistencia do lancamento.
- [ ] **Criterion 2:** O smoke test cobre ao menos um caso de despesa ou credito com impacto observavel no saldo.
- [ ] **Criterion 3:** O resultado esperado inclui pontos claros de verificacao em webhook, processamento, resposta e saldo final.
- [ ] **Criterion 4:** Falhas comuns ficam associadas a diagnosticos iniciais para reduzir tempo de troubleshooting.

## Technical Notes

### Implementation Approach

Criar um checklist operacional simples e repetivel que amarre WAHA, webhook, resolucao de contato, conversa guiada e ledger. O objetivo e comprovar integracao funcional entre modulos ja entregues, nao criar nova camada de automacao complexa.

### Files/Modules Affected

- documentacao operacional principal do projeto
- scripts leves de smoke check, se isso simplificar a execucao
- eventuais testes de integracao, se o ambiente permitir

### Data Model Changes

- nenhuma mudanca obrigatoria

### API Changes

- nenhuma mudanca obrigatoria

### Edge Cases

- **Mensagem chega mas membro nao e reconhecido:** apontar verificacao do contato WhatsApp.
- **Webhook recebe evento mas conversa nao avanca:** apontar verificacao de fila, logs e sessao.
- **Conversa conclui sem atualizar saldo:** apontar verificacao de ledger e conta escolhida.

### Performance Considerations

Sem requisitos adicionais; foco em confiabilidade e observabilidade operacional.

### Security Considerations

- mascarar dados sensiveis em exemplos de teste
- nao registrar segredos reais em roteiros de validacao

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-016` - setup do WAHA e credenciais precisa estar estabilizado
- **Blocked by:** `STORY-018` - contato autorizado precisa estar configurado
- **Blocked by:** `STORY-011` e `STORY-012` - fluxos guiados ja precisam existir
- **Blocks:** nenhuma historia direta; reduz risco para a proxima fase

### Technical Dependencies

- stack local funcional
- fila e webhook operacionais
- ao menos uma conta valida cadastrada para a familia

### Open Questions

- [ ] O smoke test sera apenas manual ou tera um pequeno script de apoio para health checks?

## Testing Requirements

### Unit Tests

- [ ] Nao obrigatorios, salvo se houver script ou helper novo

### Integration Tests

- [ ] Validar pelo menos um caminho conversacional representativo se o ambiente local suportar automacao

### Manual Testing

- [ ] Enviar mensagem inicial pelo WhatsApp
- [ ] Completar um fluxo guiado
- [ ] Confirmar resposta recebida e impacto no saldo

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

Esta historia nao adiciona escopo de produto visivel, mas reduz fortemente o risco de integracao entre os modulos mais sensiveis do MVP.

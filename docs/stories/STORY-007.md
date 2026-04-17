# Expor consulta de saldo consolidado e por conta

- **ID:** STORY-007
- **Epic:** Motor financeiro basico
- **Priority:** Must Have
- **Story Points:** 3
- **Status:** Not Started

## User Story

As a **administrador ou membro autorizado**
I want to **consultar o saldo total da familia e o saldo por conta**
So that **eu tenha visibilidade rapida da situacao financeira atual**

## Acceptance Criteria

- [ ] **Criterion 1:** Existe endpoint autenticado para retornar o saldo consolidado da familia.
- [ ] **Criterion 2:** O payload inclui lista de contas com saldo individual e identificacao minima.
- [ ] **Criterion 3:** O endpoint respeita o escopo de `family_id` do usuario autenticado.
- [ ] **Criterion 4:** A resposta informa referencia temporal minima de atualizacao ou calculo.
- [ ] **Criterion 5:** O contrato retornado e simples o suficiente para reutilizacao posterior no frontend Vue e no modulo de mensagens.

## Technical Notes

### Implementation Approach

Construir um caso de uso de leitura no modulo `Ledger` que agregue o saldo por conta a partir de `bank_accounts.current_balance` ou estrutura equivalente, sem introduzir CQRS ou snapshots complexos nesta fase.

### Files/Modules Affected

- `laravel/app/Modules/Ledger/` - query service e controller de saldo
- `laravel/app/Modules/Banking/` - possivel ajuste de relacoes e serializacao de contas
- `laravel/tests/Feature/Ledger/` - testes de consulta de saldo
- documentacao de API no `README` ou notas modulares

### Data Model Changes

- nenhuma tabela nova obrigatoria, assumindo reutilizacao de `bank_accounts.current_balance`
- opcionalmente adicionar `updated_at` consistente na conta como referencia de ultima alteracao

### API Changes

- `GET /api/v1/balances`
- possivel suporte opcional a filtro por conta no futuro, sem ser obrigatorio agora

### Edge Cases

- **Familia sem contas:** retornar total zero e lista vazia.
- **Conta inativa com historico:** decidir se aparece na lista inicial com flag de status.
- **Sem movimentacoes apos saldo inicial:** saldo deve refletir o valor de abertura configurado.

### Performance Considerations

Evitar recomputar saldo a partir de todas as transacoes nesta historia; priorizar leitura simples e pagavel sobre dados ja consolidados.

### Security Considerations

- garantir que apenas membros autenticados da familia consultem os dados
- evitar vazamento de contas de outra familia por joins sem filtro

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-006` - o ledger minimo precisa existir para o contrato ser validado
- **Blocks:** `STORY-010` - a consulta via WhatsApp depende desta leitura de saldo

### Technical Dependencies

- `BankAccount.current_balance` consistente
- middleware `family.context` em funcionamento
- contrato de resposta alinhado ao modulo `Messaging`

### Open Questions

- [ ] O payload inicial deve incluir apenas contas ativas ou tambem contas inativas com identificacao de status?
- [ ] A referencia temporal sera `generated_at` da resposta ou `last_transaction_at` derivado do ledger?

## Testing Requirements

### Unit Tests

- [ ] Validar agregacao do saldo total a partir das contas da familia
- [ ] Validar exclusao de contas fora do escopo
- [ ] Validar comportamento para familia sem contas

### Integration Tests

- [ ] Consultar saldo consolidado com token valido retorna `200`
- [ ] Consultar saldo de familia autenticada retorna total coerente com as contas
- [ ] Requisicao sem token retorna `401`

### Manual Testing

- [ ] Criar contas e movimentacoes, depois consultar o resumo financeiro
- [ ] Validar resposta para familia com apenas saldo inicial
- [ ] Conferir se o payload e legivel para reuso no WhatsApp

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

Esta historia cobre principalmente `FR-008` e prepara o contrato de saldo que sera consumido imediatamente em `STORY-010`.

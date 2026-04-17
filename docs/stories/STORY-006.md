# Implementar motor de lancamentos manuais de despesa e receita

- **ID:** STORY-006
- **Epic:** Motor financeiro basico
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **membro autorizado da familia**
I want to **registrar manualmente uma despesa ou um credito em uma conta**
So that **o saldo financeiro da familia reflita corretamente as movimentacoes do dia a dia**

## Acceptance Criteria

- [x] **Criterion 1:** Existe endpoint autenticado para registrar despesa com valor, conta, data efetiva e descricao minima.
- [x] **Criterion 2:** Existe endpoint autenticado para registrar credito com valor, conta, data efetiva e descricao minima.
- [x] **Criterion 3:** O saldo corrente da conta e atualizado de forma consistente apos a persistencia da movimentacao.
- [x] **Criterion 4:** Toda movimentacao grava `family_id`, `account_id`, tipo, actor, canal de origem e timestamps.
- [x] **Criterion 5:** O backend rejeita conta fora do escopo da familia autenticada e payloads invalidos com resposta apropriada.

## Technical Notes

### Implementation Approach

Implementar o primeiro fluxo do modulo `Ledger` com actions separadas para despesa e credito, persistencia transacional e atualizacao atomica do saldo em `BankAccount`. A primeira iteracao deve ser simples, sem categorias, parcelamento ou estorno avancado.

### Files/Modules Affected

- `laravel/app/Modules/Ledger/` - novo modulo funcional de transacoes e saldo
- `laravel/app/Modules/Banking/Domain/Models/BankAccount.php` - atualizacao do saldo corrente e relacoes
- `laravel/database/migrations/` - tabelas de transacoes e eventuais indices
- `laravel/tests/Feature/Ledger/` - testes de API e escopo por familia

### Data Model Changes

- criar tabela `transactions` com `family_id`, `bank_account_id`, `type`, `amount`, `effective_date`, `description`, `origin_channel`, `created_by`
- considerar enums ou constantes para `expense` e `credit`
- adicionar indices por `family_id`, `bank_account_id` e `effective_date`

### API Changes

- `POST /api/v1/transactions/expenses`
- `POST /api/v1/transactions/credits`
- autenticacao via `jwt.auth` e escopo via `family.context`

### Edge Cases

- **Saldo inicial zero:** a conta deve aceitar o primeiro lancamento normalmente.
- **Valor negativo ou zero:** rejeitar com erro de validacao.
- **Conta de outra familia:** retornar `404` ou `403` conforme padrao adotado no modulo financeiro.

### Performance Considerations

As operacoes devem usar transacao de banco para evitar drift de saldo e consultar apenas a conta-alvo no escopo da familia autenticada.

### Security Considerations

- validar ownership da conta por `family_id`
- impedir mass assignment de campos sensiveis
- normalizar valores monetarios antes de persistir
- manter autenticacao e autorizacao consistentes com o modulo `Identity`

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-005` - a estrutura minima de bancos e contas precisa existir
- **Blocks:** `STORY-007` - consulta de saldo depende de movimentacoes reais

### Technical Dependencies

- modelos de `Bank` e `BankAccount` operacionais
- middleware de autenticacao e contexto familiar funcionando
- decisao de modelagem minima do ledger alinhada ao PRD e arquitetura

### Open Questions

- [x] O endpoint de transacao deve ser unificado ou manter rotas separadas para despesa e credito na primeira iteracao?
- [x] O campo `origin_channel` ja deve prever valores como `web`, `whatsapp` e `system` desde a primeira migration?

## Testing Requirements

### Unit Tests

- [ ] Validar regra que despesa reduz saldo e credito aumenta saldo
- [ ] Validar rejeicao de valor invalido
- [ ] Validar calculo do saldo apos multiplas movimentacoes

### Integration Tests

- [ ] Registrar despesa em conta da familia autenticada com retorno de sucesso
- [ ] Registrar credito em conta da familia autenticada com saldo atualizado
- [ ] Tentar registrar movimentacao em conta fora do escopo da familia e receber erro

### Manual Testing

- [ ] Criar conta com saldo inicial e registrar uma despesa
- [ ] Registrar um credito e confirmar refletancia no saldo
- [ ] Verificar mensagens de erro para payload invalido

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

Implementacao concluida com migration `transactions`, model `Transaction`, action transacional `RecordTransactionAction`, requests e controllers para `POST /api/v1/transactions/expenses` e `POST /api/v1/transactions/credits`, alem de `BalanceCalculator` para a regra de saldo. Os testes `BalanceCalculatorTest`, `LedgerTransactionTest` e `BankingSetupTest` passaram no container.

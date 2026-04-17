# Entregar cadastro inicial de bancos, contas e saldo inicial

- **ID:** STORY-005
- **Epic:** Estrutura financeira inicial
- **Priority:** Should Have
- **Story Points:** 2
- **Status:** Completed

## User Story

As a **administrador da familia**
I want to **cadastrar bancos, contas e saldo inicial**
So that **a familia tenha a estrutura minima para registrar movimentacoes nas proximas historias**

## Acceptance Criteria

- [x] **Criterion 1:** Existe endpoint autenticado para cadastrar banco no contexto da familia.
- [x] **Criterion 2:** Existe endpoint autenticado para cadastrar conta vinculada a um banco e a uma familia.
- [x] **Criterion 3:** O cadastro da conta aceita saldo inicial, incluindo valor zero.
- [x] **Criterion 4:** A conta e o banco ficam escopados corretamente pela familia autenticada.
- [x] **Criterion 5:** O retorno da API apresenta os dados minimos necessarios para uso posterior no ledger.

## Technical Notes

### Implementation Approach

Implementar os casos de uso minimos no modulo `Banking`, integrados ao contexto da familia ja criado em `Families`. A historia deve permanecer enxuta, sem entrar ainda em historico completo de saldo ou conciliacao.

### Files/Modules Affected

- `laravel/app/Modules/Banking/`
- migrations de `banks` e `bank_accounts`
- rotas e controllers REST de bancos e contas
- integracao com policies baseadas em familia

### Data Model Changes

- tabela `banks`
- tabela `bank_accounts`
- campo ou estrategia para armazenar `initial_balance`

### API Changes

- `POST /api/v1/banks`
- `GET /api/v1/banks` opcional se necessario para uso imediato
- `POST /api/v1/accounts`

### Edge Cases

- **Saldo inicial zero:** deve ser aceito explicitamente
- **Banco inativo ou duplicado:** decidir validacao minima coerente com o MVP
- **Conta criada para familia errada:** rejeitar por autorizacao ou validacao de escopo

### Performance Considerations

Baixa complexidade; usar indices basicos por `family_id` e `status` desde o inicio.

### Security Considerations

- endpoints autenticados
- validacao de escopo por familia
- validacao numerica segura de valores monetarios

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-004` - depende da existencia de uma familia valida e contexto autenticado
- **Blocks:** nenhuma historia da sprint atual; prepara as proximas historias de ledger

### Technical Dependencies

- modulo `Banking` criado
- migrations e policies basicas por familia

### Open Questions

- [x] O banco sera entidade livre por familia ou havera catalogo compartilhado no futuro?
- [x] O saldo inicial sera persistido apenas em `bank_accounts` ou em uma entidade especifica de abertura?

## Testing Requirements

### Unit Tests

- [ ] Validar criacao de banco no escopo da familia
- [ ] Validar criacao de conta com saldo inicial zero ou positivo
- [ ] Validar restricao de escopo por familia

### Integration Tests

- [ ] Criar banco autenticado retorna `201`
- [ ] Criar conta autenticada retorna `201`
- [ ] Tentar criar conta em familia nao autorizada retorna `403`

### Manual Testing

- [ ] Cadastrar banco
- [ ] Cadastrar conta com saldo zero
- [ ] Cadastrar conta com saldo positivo

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

Implementacao concluida com `POST /api/v1/banks` e `POST /api/v1/accounts`, entidades `Bank` e `BankAccount`, migrations de `banks` e `bank_accounts`, validacao de saldo inicial incluindo zero e checagem de escopo por familia autenticada.

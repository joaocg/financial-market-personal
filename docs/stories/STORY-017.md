# Painel Vue para cadastro de bancos e contas

- **ID:** STORY-017
- **Epic:** Frontend administrativo de estrutura financeira
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **administrador da familia**
I want to **cadastrar bancos e contas pela interface Vue**
So that **eu consiga preparar a estrutura financeira sem depender de chamadas manuais a API**

## Acceptance Criteria

- [x] **Criterion 1:** O frontend exibe uma area administrativa para criar banco e conta no contexto da familia autenticada.
- [x] **Criterion 2:** O fluxo permite informar nome do banco, nome da conta e saldo inicial, incluindo valor zero.
- [x] **Criterion 3:** O painel apresenta estados de sucesso, erro e carregamento sem quebrar a navegacao.
- [x] **Criterion 4:** O usuario consegue visualizar as contas ja cadastradas apos a criacao.
- [x] **Criterion 5:** O frontend reutiliza os contratos existentes do backend sem criar divergencia de payload.

## Technical Notes

### Implementation Approach

Expandir a base Vue criada em `STORY-013` e `STORY-014` com uma superficie administrativa enxuta, priorizando clareza, validacao simples e continuidade visual. O foco e fechar o cadastro minimo de estrutura financeira do MVP, nao construir um modulo completo de gestao.

### Files/Modules Affected

- `laravel/resources/js/` ou equivalente do frontend Vue
- `laravel/resources/css/` ou equivalente, se ajustes visuais forem necessarios
- `laravel/app/Modules/Banking/Interfaces/Http/Controllers/` apenas se faltar endpoint de listagem minimo
- `laravel/tests/Feature/Frontend/` e testes do frontend Vue

### Data Model Changes

- nenhuma mudanca obrigatoria

### API Changes

- reutilizar `POST /api/v1/banks`
- reutilizar `POST /api/v1/accounts`
- adicionar `GET /api/v1/banks` e `GET /api/v1/accounts` apenas se o frontend realmente precisar de leitura dedicada e isso ainda nao existir

### Edge Cases

- **Saldo inicial zero:** deve funcionar sem ambiguidade na interface.
- **Nenhum banco cadastrado ainda:** orientar o usuario a criar o primeiro banco antes da conta.
- **Erro de validacao da API:** mapear mensagens para uma apresentacao compreensivel.

### Performance Considerations

Evitar navegação pesada e reaproveitar a sessao ja carregada no painel atual.

### Security Considerations

- manter autenticacao JWT e contexto de familia
- nao permitir cadastro fora do escopo da familia autenticada
- validar e sanitizar campos numericos e textuais antes do envio

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-005` - os contratos de bancos e contas precisam existir e estar estaveis
- **Blocked by:** `STORY-013` - a base de frontend autenticado ja precisa existir
- **Blocks:** `STORY-019` de forma indireta, ao facilitar a preparacao da estrutura necessaria para os fluxos conversacionais

### Technical Dependencies

- rotas autenticadas de `banks` e `accounts`
- sessao JWT restaurada no frontend
- componentes base do painel Vue existentes

### Open Questions

- [ ] O painel mostrara apenas criacao e listagem simples nesta iteracao ou ja permitira inativacao?
- [ ] O cadastro de banco ficara embutido na mesma tela da conta ou em passos separados?

## Testing Requirements

### Unit Tests

- [x] Validar renderizacao do formulario de banco
- [x] Validar renderizacao do formulario de conta
- [x] Validar estados de erro e sucesso

### Integration Tests

- [x] Criar banco pelo frontend e confirmar chamada correta para a API
- [x] Criar conta pelo frontend e confirmar atualizacao da lista

### Manual Testing

- [x] Entrar no painel autenticado
- [x] Cadastrar um banco
- [x] Cadastrar uma conta com saldo zero e outra com saldo positivo

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

Esta historia transforma o frontend atual de superficie de leitura em um painel minimo de operacao administrativa, essencial para onboarding financeiro real.

## Delivery Notes

- O painel Vue agora cria bancos e contas no contexto autenticado da familia.
- O saldo inicial zero e tratado sem ambiguidade.
- As listas de bancos e contas sao recarregadas apos a criacao com estados claros de loading, erro e sucesso.
- Validacao coberta por testes de backend e frontend.

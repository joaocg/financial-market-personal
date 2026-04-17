# Painel Vue para saldo consolidado e contas

- **ID:** STORY-014
- **Epic:** Frontend Vue inicial
- **Priority:** Must Have
- **Story Points:** 3
- **Status:** Not Started

## User Story

As a **membro da familia**
I want to **ver o saldo consolidado e o saldo por conta em um painel Vue**
So that **eu acompanhe a situacao financeira de forma rapida e visual**

## Acceptance Criteria

- [ ] **Criterion 1:** O painel exibe o saldo consolidado da familia.
- [ ] **Criterion 2:** O painel exibe o saldo por conta de forma legivel.
- [ ] **Criterion 3:** Os dados sao carregados a partir do contrato de consulta de saldo existente.
- [ ] **Criterion 4:** O usuario recebe estado de carregamento e erro de forma clara.
- [ ] **Criterion 5:** A visualizacao funciona em desktop e mobile sem quebrar o layout.

## Technical Notes

### Implementation Approach

Construir uma tela enxuta de saldo como primeira pagina funcional do frontend, usando o contrato de consulta ja existente no backend. O foco e legibilidade, nao densidade de informacao.

### Files/Modules Affected

- `laravel/resources/js/` ou equivalente do frontend Vue - tela de saldo e componentes auxiliares
- `laravel/resources/css/` ou equivalente - layout, tipografia e estados visuais
- `laravel/tests/Feature/Frontend/` - verificacao da renderizacao ou integracao com dados simulados

### Data Model Changes

- nenhuma mudanca obrigatoria

### API Changes

- reuso do contrato de saldo consolidado e por conta criado em `STORY-007`
- sem novos endpoints nesta historia

### Edge Cases

- **Sem contas cadastradas:** mostrar estado vazio explicativo.
- **Falha na API:** mostrar mensagem curta e acao de re-tentativa.
- **Saldo negativo:** manter destaque visual sem mascarar o valor real.

### Performance Considerations

Carregar apenas os dados necessarios para o resumo financeiro inicial, evitando listas ou widgets pesados.

### Security Considerations

- exibir saldo apenas para o membro autenticado
- nao persistir informacoes sensiveis no cliente alem do necessario
- tratar erros sem vazar detalhes internos da API

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-007` - o contrato de consulta de saldo precisa existir e estar estavel
- **Blocked by:** `STORY-013` - a base visual e de navegacao do frontend deve estar pronta
- **Blocks:** nenhuma historia direta nesta sprint

### Technical Dependencies

- stack Vue disponivel no projeto
- endpoint de consulta de saldo funcional
- mecanismo de autenticacao ou contexto de membro

### Open Questions

- [ ] O painel deve mostrar saldo total apenas ou tambem um resumo de ultimas movimentacoes?
- [ ] O uso inicial sera como pagina dedicada ou como componente dentro de um dashboard maior?

## Testing Requirements

### Unit Tests

- [ ] Validar renderizacao do saldo consolidado
- [ ] Validar renderizacao do saldo por conta
- [ ] Validar estados de loading e erro

### Integration Tests

- [ ] Consumir a API de saldo e montar o painel com dados reais ou mockados
- [ ] Validar responsividade em viewport mobile

### Manual Testing

- [ ] Abrir o painel e conferir a leitura do saldo
- [ ] Verificar o comportamento ao simular erro de API

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

Esta historia fecha a primeira superficie util do frontend para leitura financeira.


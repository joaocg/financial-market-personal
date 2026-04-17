# Painel Vue para login e onboarding inicial

- **ID:** STORY-013
- **Epic:** Frontend Vue inicial
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **novo membro da familia**
I want to **acessar uma tela inicial de login e onboarding em Vue**
So that **eu consiga entrar no sistema e entender o proximo passo de uso**

## Acceptance Criteria

- [x] **Criterion 1:** O painel exibe uma tela inicial clara para login ou acesso inicial.
- [x] **Criterion 2:** O usuario recebe orientacao curta sobre o proposito do produto e o primeiro passo.
- [x] **Criterion 3:** O fluxo de entrada funciona bem em desktop e mobile.
- [x] **Criterion 4:** O estado de autenticacao ou inicio de sessao eh tratado sem quebrar a navegacao.
- [x] **Criterion 5:** Erros de acesso ou indisponibilidade sao apresentados de forma simples e segura.

## Technical Notes

### Implementation Approach

Criar a primeira superficie de frontend em Vue com foco em entrada, orientacao e consistencia visual com o MVP. A experiencia deve ser simples e pronta para receber proximas telas sem retrabalho estrutural.

### Files/Modules Affected

- `laravel/resources/js/` ou equivalente do frontend Vue - tela inicial, componentes e rotas
- `laravel/resources/css/` ou equivalente - estilos base do onboarding
- `laravel/tests/Feature/Frontend/` - testes de navegacao e renderizacao, se aplicavel

### Data Model Changes

- nenhuma mudanca obrigatoria

### API Changes

- pode reutilizar o endpoint de autenticacao existente
- sem necessidade de novos contratos publicos nesta historia

### Edge Cases

- **Usuario deslogado:** redirecionar para a tela inicial sem erro tecnico.
- **Tela em mobile pequeno:** preservar leitura e acesso aos elementos principais.
- **Falha na autenticacao:** mostrar mensagem objetiva e nao tecnica.

### Performance Considerations

A tela deve carregar rapido e evitar dependencias pesadas para nao atrasar a primeira interacao do usuario.

### Security Considerations

- nao exibir informacoes sensiveis na tela inicial
- manter fluxos de autenticacao consistentes com o backend existente
- validar entrada antes de enviar para a API

## Dependencies

### Story Dependencies

- **Blocked by:** nenhuma dependencia funcional direta nesta sprint
- **Blocks:** `STORY-014` - a tela de saldo consolidado depende da base visual e da navegacao inicial

### Technical Dependencies

- stack Vue ja disponivel no projeto
- rotas de frontend definidas para a aplicacao
- componente de autenticacao ou onboarding reutilizavel

### Open Questions

- [x] O login usa o fluxo proprio da tela inicial com JWT.
- [x] O onboarding usa copy generica para familia, conta e membro.

## Testing Requirements

### Unit Tests

- [x] Validar renderizacao da tela inicial
- [x] Validar mensagem de onboarding
- [x] Validar comportamento para estado nao autenticado

### Integration Tests

- [x] Abrir a aplicacao e navegar ate a tela inicial
- [x] Validar responsividade basica em viewport menor

### Manual Testing

- [x] Abrir o frontend em desktop e verificar a primeira tela
- [x] Abrir o frontend em mobile e verificar usabilidade basica

## Definition of Done

This story is considered complete when:

- [ ] Code is written and follows project coding standards
- [x] Code is written and follows project coding standards
- [x] All acceptance criteria are met and verified
- [x] Unit tests are written and passing (>80% coverage for new code)
- [x] Integration tests are written and passing (if applicable)
- [ ] Code has been reviewed and approved by at least one team member
- [x] No critical or high-priority bugs remain
- [x] Documentation is updated (README, API docs, inline comments)
- [ ] Changes are merged to main/development branch
- [ ] Deployed to local development environment
- [ ] Product owner has reviewed and accepted the story

## Notes

Primeira entrega visivel do frontend Vue, pensada como base para as proximas telas do MVP. A pagina inicial restaura sessao JWT salva, renova token expirado e mostra o contexto da familia quando autenticado.

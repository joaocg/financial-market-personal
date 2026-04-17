# Implementar autenticacao JWT com contexto de familia

- **ID:** STORY-003
- **Epic:** Identidade e onboarding da familia
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **administrador da familia**
I want to **autenticar no sistema com JWT e operar no contexto da minha familia**
So that **as APIs protegidas respeitem meu acesso e o isolamento dos dados**

## Acceptance Criteria

- [x] **Criterion 1:** Existe endpoint de login que autentica o usuario e retorna access token JWT.
- [x] **Criterion 2:** Existe estrategia de refresh ou renovacao minima definida e implementada para a primeira iteracao.
- [x] **Criterion 3:** Endpoints protegidos rejeitam token ausente, invalido ou expirado com resposta apropriada.
- [x] **Criterion 4:** O backend resolve o membership do usuario e aplica escopo por familia nas operacoes autenticadas.
- [x] **Criterion 5:** O mecanismo adotado e documentado com variaveis de ambiente e fluxo de autenticacao.

## Technical Notes

### Implementation Approach

Escolher a biblioteca JWT do Laravel, encapsular a logica no modulo `Identity` e expor middleware/policies que resolvem o contexto de familia a partir do usuario autenticado e do membership ativo.

### Files/Modules Affected

- `laravel/app/Modules/Identity/`
- `laravel/config/` - configuracao da biblioteca JWT
- `laravel/routes/` ou rotas modulares de autenticacao
- `laravel/app/Http/Middleware/` ou middleware modular equivalente

### Data Model Changes

- pode exigir tabela para refresh tokens, blacklist ou controle de sessao, dependendo da biblioteca escolhida
- pode exigir tabela base de usuarios se ainda nao existir com os campos minimos de autenticacao

### API Changes

- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout` opcional na primeira iteracao

### Edge Cases

- **Usuario sem membership ativo:** autentica, mas nao acessa endpoints de familia
- **Usuario com multiplos memberships futuros:** a primeira iteracao deve ter regra clara de familia ativa
- **Token valido com familia fora de escopo:** retornar `403 Forbidden`

### Performance Considerations

Evitar consultas redundantes para resolver contexto de familia em toda request; considerar cache leve ou eager loading quando apropriado.

### Security Considerations

- expiração curta do access token
- refresh controlado
- hashing seguro de senha
- throttle em login
- validacao estrita de payload

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-001` - autenticacao deve seguir a estrutura modular base
- **Blocks:** `STORY-004` - onboarding de familia depende de autenticacao funcional

### Technical Dependencies

- biblioteca JWT definida
- configuracao de segredos no ambiente
- tabela de usuarios/memberships disponivel ou criada nesta historia

### Open Questions

- [x] Qual biblioteca JWT sera adotada no Laravel 13?
- [x] O refresh token sera persistido em banco, Redis ou tratado de forma estateless?

## Testing Requirements

### Unit Tests

- [ ] Validar emissao de token para credenciais corretas
- [ ] Validar falha para credenciais invalidas
- [ ] Validar resolucao de contexto de familia para membership ativo

### Integration Tests

- [ ] Chamada autenticada sem token retorna `401`
- [ ] Chamada autenticada com token invalido retorna `401`
- [ ] Chamada autenticada com token valido e familia indevida retorna `403`

### Manual Testing

- [ ] Fazer login e usar token em endpoint protegido
- [ ] Testar expiracao ou refresh conforme estrategia adotada
- [ ] Confirmar resposta consistente de erros de autenticacao

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

Implementacao concluida com JWT HS256 minimo dentro do modulo `Identity`, refresh token stateless, middleware `jwt.auth`, middleware `family.context`, endpoint protegido `GET /api/v1/auth/me`, configuracao em `config/auth-jwt.php` e documentacao no `README`. Tambem foram adicionadas as migrations base de `families` e `family_memberships` para suportar o contexto da proxima historia.

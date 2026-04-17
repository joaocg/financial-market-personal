# Entregar API de criacao de familia e gestao basica de membros

- **ID:** STORY-004
- **Epic:** Identidade e onboarding da familia
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Not Started

## User Story

As a **administrador da familia**
I want to **criar minha familia e cadastrar o primeiro membro com papel e idioma**
So that **o sistema passe a ter um contexto real de operacao e permissao**

## Acceptance Criteria

- [ ] **Criterion 1:** Existe endpoint autenticado para criar uma familia e vincular o usuario logado como administrador inicial.
- [ ] **Criterion 2:** Existe endpoint para cadastrar o primeiro membro com papel e idioma preferencial.
- [ ] **Criterion 3:** Os dados criados ficam corretamente vinculados ao contexto da familia.
- [ ] **Criterion 4:** O sistema impede operacoes fora do escopo da familia do usuario autenticado.
- [ ] **Criterion 5:** A resposta da API fornece os identificadores necessarios para continuar o onboarding.

## Technical Notes

### Implementation Approach

Implementar a historia nos modulos `Families` e `Identity`, com controllers, casos de uso e repositorios separados. O foco e o onboarding minimo: criar familia, membership inicial e primeiro membro, sem complexificar com convites completos nesta iteracao.

### Files/Modules Affected

- `laravel/app/Modules/Families/`
- `laravel/app/Modules/Identity/` - integracao com usuario autenticado e membership
- migrations relacionadas a `families`, `family_memberships` e contatos basicos
- rotas REST do onboarding

### Data Model Changes

- tabela `families`
- tabela `family_memberships`
- tabela `member_contacts` ou equivalente, se o primeiro membro ja exigir contato

### API Changes

- `POST /api/v1/families`
- `POST /api/v1/families/{familyId}/members`
- `GET /api/v1/families/current` opcional para conferir contexto atual

### Edge Cases

- **Usuario tenta criar familia duplicada:** regra deve ser clara e validada
- **Idioma ausente no payload do membro:** usar default definido pelo sistema ou exigir valor
- **Membro sem usuario associado ainda:** permitir cadastro basico sem obrigar conta completa

### Performance Considerations

Fluxo de escrita simples; priorizar consistencia e clareza da API sobre micro-otimizacoes.

### Security Considerations

- endpoints autenticados
- validacao de papel permitido
- escopo estrito por familia
- sanitizacao de campos de entrada

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-003` - depende de autenticacao e contexto de usuario
- **Blocks:** `STORY-005` - conta bancaria precisa nascer dentro de uma familia criada

### Technical Dependencies

- modulo `Families` inicializado
- mecanismo de policies ou autorizacao por membership

### Open Questions

- [ ] O primeiro membro cadastrado apos o admin sera sempre manual ou ja deve suportar convite pendente?
- [ ] O idioma sera armazenado no membership, no contato ou em entidade separada de perfil?

## Testing Requirements

### Unit Tests

- [ ] Validar criacao de familia com administrador inicial
- [ ] Validar criacao de membro com papel e idioma
- [ ] Validar recusa de acesso fora do escopo da familia

### Integration Tests

- [ ] Criar familia autenticado retorna `201`
- [ ] Criar membro para familia valida retorna `201`
- [ ] Tentar operar em familia nao autorizada retorna `403`

### Manual Testing

- [ ] Criar familia com usuario autenticado
- [ ] Cadastrar membro inicial
- [ ] Verificar retorno dos IDs e dados essenciais

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

Convites sofisticados, vinculo por WhatsApp e gestao completa de membros continuam fora do escopo desta historia. O objetivo e destravar o onboarding minimo do dominio.

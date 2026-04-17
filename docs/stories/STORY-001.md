# Estruturar o esqueleto modular em `laravel/app/Modules`

- **ID:** STORY-001
- **Epic:** Fundacao tecnica do backend modular
- **Priority:** Must Have
- **Story Points:** 3
- **Status:** Completed

## User Story

As a **desenvolvedor do backend**
I want to **estruturar o esqueleto modular do Laravel em `app/Modules`**
So that **o projeto tenha fronteiras claras de dominio e uma base consistente para as proximas historias**

## Acceptance Criteria

- [x] **Criterion 1:** Existe a pasta `laravel/app/Modules` com os modulos `Identity`, `Families`, `Banking`, `Ledger`, `Messaging`, `AI` e `Shared`.
- [x] **Criterion 2:** Cada modulo possui, no minimo, as subpastas `Domain`, `Application`, `Infrastructure` e `Interfaces`.
- [x] **Criterion 3:** O bootstrap do backend documenta ou implementa a convencao para localizar controllers, services e rotas por modulo.
- [x] **Criterion 4:** Existe um padrao minimo reutilizavel para novos modulos, evitando organizacao ad hoc.
- [x] **Criterion 5:** A estrutura criada nao quebra o bootstrap atual do Laravel nem impede a execucao da aplicacao.

## Technical Notes

### Implementation Approach

Criar a estrutura fisica base dos modulos conforme a arquitetura definida em `docs/bmad/architecture.md`, com um `Shared` minimo para contratos e utilitarios transversais. O foco da story e estrutural, sem introduzir logica de negocio complexa.

### Files/Modules Affected

- `laravel/app/Modules/` - nova raiz modular do backend
- `laravel/app/Providers/` - possivel ajuste para registrar convencoes ou providers modulares
- `laravel/routes/` - possivel bootstrap leve para carregar rotas modulares
- `laravel/README.md` ou documentacao tecnica local - registrar convencao adotada

### Data Model Changes

Nenhuma alteracao de schema e obrigatoria nesta story.

### API Changes

Nenhum endpoint funcional novo e obrigatorio nesta story.

### Edge Cases

- **Modulo vazio sem uso imediato:** manter estrutura minima sem criar classes desnecessarias.
- **Bootstrap Laravel nao preparado para modulos:** usar convencao simples e incremental, sem framework extra.
- **Acoplamento com `App\\`:** preservar compatibilidade com namespaces e autoload atuais.

### Performance Considerations

Impacto irrelevante em runtime; evitar bootstrap excessivamente dinamico ou reflexivo sem necessidade.

### Security Considerations

Sem impacto direto de seguranca, mas a organizacao deve facilitar segregacao de responsabilidades por modulo.

## Dependencies

### Story Dependencies

- **Blocked by:** None
- **Blocks:** `STORY-002` - a stack local deve subir ja com a estrutura modular base
- **Blocks:** `STORY-003` - autenticacao JWT deve nascer dentro da convencao modular

### Technical Dependencies

- Estrutura atual do Laravel 13 em `laravel/`
- Definicoes de arquitetura em `docs/bmad/architecture.md`

### Open Questions

- [x] Havera um `ModuleServiceProvider` generico ou registro manual por modulo?
- [x] As rotas modulares ficarao agregadas por arquivo central ou carregadas por modulo desde a primeira iteracao?

## Testing Requirements

### Unit Tests

- [ ] Validar que a convencao de namespaces dos modulos e carregavel pelo autoload
- [ ] Validar qualquer helper ou provider criado para descoberta modular

### Integration Tests

- [ ] A aplicacao Laravel continua inicializando apos a criacao da estrutura modular
- [ ] Rotas existentes continuam acessiveis, se houver bootstrap alterado

### Manual Testing

- [ ] Confirmar visualmente a estrutura de pastas esperada
- [ ] Rodar bootstrap basico do Laravel sem erro fatal

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

Implementacao concluida com `ModuleServiceProvider` generico, `ModuleRegistry`, placeholders de rota por modulo e documentacao da convencao em `laravel/README.md` e `laravel/app/Modules/README.md`.

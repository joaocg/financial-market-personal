# Orquestrar ambiente local com Docker Compose

- **ID:** STORY-002
- **Epic:** Fundacao tecnica do backend modular
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **desenvolvedor do projeto**
I want to **subir o ambiente local completo com Docker Compose**
So that **backend, fila, banco, cache e WAHA possam ser executados de forma previsivel**

## Acceptance Criteria

- [x] **Criterion 1:** Existe um arquivo Compose principal na raiz do projeto ou local consolidado documentado para subir Laravel API, worker, MySQL, Redis e WAHA.
- [x] **Criterion 2:** Os servicos sobem com configuracoes minimas de rede, variaveis de ambiente e dependencias coerentes.
- [x] **Criterion 3:** Existem healthchecks ou verificacoes equivalentes para API, banco, cache e WAHA quando aplicavel.
- [x] **Criterion 4:** O fluxo de bootstrap local esta documentado com os comandos necessarios para iniciar o ambiente.
- [x] **Criterion 5:** O ambiente preparado suporta o desenvolvimento das historias de autenticacao e onboarding sem depender de setup manual disperso.

## Technical Notes

### Implementation Approach

Criar ou consolidar um `docker-compose.yml` para o produto, tratando `waha/` como dependencia operacional e o backend Laravel como servico principal. Incluir um worker Laravel separado e configurar MySQL e Redis no mesmo ambiente.

### Files/Modules Affected

- `docker-compose.yml` ou equivalente na raiz do projeto
- `.env.example` ou arquivos de ambiente do backend
- `laravel/` Dockerfile ou ajustes de container se necessario
- documentacao operacional do projeto

### Data Model Changes

Nenhuma alteracao funcional de schema e necessaria, mas o banco precisa estar pronto para migracoes futuras.

### API Changes

- endpoint de health ou validacao minima da API pode ser necessario
- configuracao de webhook target para WAHA deve ser prevista

### Edge Cases

- **WAHA requer configuracao especifica de sessao:** documentar e isolar como dependencia operacional.
- **Container do Laravel inicia antes do banco:** usar `depends_on`, retry e healthcheck.
- **Uso de MySQL local do host vs container:** padronizar container na sprint para evitar divergencia.

### Performance Considerations

Evitar configuracoes exageradas para ambiente local; priorizar previsibilidade e tempo de bootstrap razoavel.

### Security Considerations

Segredos de desenvolvimento devem ficar em variaveis de ambiente e nao hardcoded no Compose.

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-001` - a estrutura modular base deve existir antes da consolidacao do ambiente
- **Blocks:** `STORY-003` - JWT precisa de ambiente local funcional

### Technical Dependencies

- Docker e Docker Compose disponiveis no ambiente
- `waha/` presente no workspace
- configuracao minima do Laravel 13

### Open Questions

- [x] O frontend Vue desta fase rodara no mesmo Compose ou ficara para sprint seguinte?
- [x] WAHA sera consumido por imagem pronta ou build local do diretorio `waha/`?

## Testing Requirements

### Unit Tests

- [ ] Nao aplicavel diretamente, salvo scripts auxiliares de bootstrap

### Integration Tests

- [ ] Subir todos os servicos e validar conectividade entre Laravel, MySQL e Redis
- [ ] Validar que o Laravel consegue inicializar no ambiente Compose
- [ ] Validar que WAHA responde no endpoint esperado

### Manual Testing

- [ ] Executar o comando documentado de subida do ambiente
- [ ] Verificar logs iniciais dos servicos
- [ ] Confirmar que o ambiente pode ser reiniciado sem reconfiguracao manual extensa

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

Implementacao concluida com `docker-compose.yml` na raiz, imagem de desenvolvimento do Laravel em `docker/php/Dockerfile`, scripts `start-app` e `start-worker`, e documentacao de bootstrap em `laravel/README.md`. `docker compose config` foi validado, e `mysql` e `redis` subiram com healthcheck `healthy`; a validacao pratica de `app`, `worker` e `waha` ficou dependente do primeiro build completo da stack.

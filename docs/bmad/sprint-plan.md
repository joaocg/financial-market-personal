# Sprint Plan: Financeiro Familiar com WhatsApp

- **Sprint Number:** 1
- **Sprint Dates:** 2026-04-17 - 2026-05-01
- **Sprint Duration:** 2 semanas / 10 dias uteis
- **Created:** 2026-04-17

## Sprint Overview

**Sprint Goal:** estabelecer a fundacao tecnica do produto e entregar o primeiro fluxo administrativo utilizavel, cobrindo autenticacao, contexto de familia, cadastro inicial da estrutura financeira e ambiente local executavel.

**Sprint Capacity:** 20 story points  
**Stories Planned:** 5 stories  
**Total Story Points:** 20 points

**Capacity Calculation:**
- **Base capacity:** 20 pontos, conforme capacidade configurada em `bmad/sprint-status.yaml`
- **Adjustments:** sem historico de velocity e sem indisponibilidades registradas; planejamento mantido de forma conservadora
- **Final capacity:** 20 pontos

## Velocity Metrics

**Historical Velocity:**
- Sprint anterior: nao disponivel
- **3-Sprint Average:** nao aplicavel

**Team Composition:**
- 1 desenvolvedor principal equivalente
- 10 dias uteis estimados nesta sprint
- 2 pontos por dev-day como taxa conservadora para inicio de projeto

## Sprint Backlog

### Epic 1: Fundacao tecnica do backend modular (8 points)

**Epic Goal:** preparar a base do backend Laravel modular e a stack local para que os proximos fluxos possam ser implementados sem retrabalho estrutural.

#### STORY-001: Estruturar o esqueleto modular em `laravel/app/Modules`
- **Priority:** Must Have
- **Points:** 3
- **Status:** Not Started
- **Dependencies:** None
- **Brief:** criar a estrutura base de modulos `Identity`, `Families`, `Banking`, `Ledger`, `Messaging`, `AI` e `Shared`, com convencoes de organizacao e bootstrap inicial.

#### STORY-002: Orquestrar ambiente local com Docker Compose
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-001
- **Brief:** disponibilizar a stack local com Laravel API, worker, MySQL, Redis e WAHA, incluindo variaveis essenciais e healthchecks iniciais.

---

### Epic 2: Identidade e onboarding da familia (10 points)

**Epic Goal:** permitir autenticacao JWT e criacao do contexto inicial da familia para habilitar o uso do sistema pelo administrador.

#### STORY-003: Implementar autenticacao JWT com contexto de familia
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-001
- **Brief:** implementar login, refresh, middleware e resolucao de membership por familia no backend.

#### STORY-004: Entregar API de criacao de familia e gestao basica de membros
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-003
- **Brief:** permitir criar familia, vincular administrador inicial e cadastrar o primeiro membro com papel e idioma.

---

### Epic 3: Estrutura financeira inicial (2 points)

**Epic Goal:** habilitar o cadastro inicial da estrutura financeira minima da familia.

#### STORY-005: Entregar cadastro inicial de bancos, contas e saldo inicial
- **Priority:** Should Have
- **Points:** 2
- **Status:** Not Started
- **Dependencies:** STORY-004
- **Brief:** criar o endpoint inicial para banco e conta com saldo de abertura, suficiente para preparar o primeiro fluxo financeiro do proximo sprint.

---

## Story Prioritization

### Must Have (Critical Path)

1. `STORY-001` - esqueleto modular do backend (3 points)
2. `STORY-002` - stack local com Docker Compose (5 points)
3. `STORY-003` - autenticacao JWT e contexto de familia (5 points)
4. `STORY-004` - criacao de familia e membros iniciais (5 points)

**Total Must Have:** 18 pontos

### Should Have (High Priority)

1. `STORY-005` - bancos, contas e saldo inicial (2 points)

**Total Should Have:** 2 pontos

### Could Have (Nice to Have)

Nenhuma historia `Could Have` foi incluída nesta sprint para evitar superalocacao no primeiro ciclo.

**Total Could Have:** 0 pontos

## Implementation Order

Recommended sequence based on dependencies and priorities:

1. **Week 1, Days 1-2:** `STORY-001` - Estruturar o esqueleto modular em `laravel/app/Modules`
   - Rationale: define a fundacao arquitetural e reduz retrabalho nas historias seguintes.

2. **Week 1, Days 3-5:** `STORY-002` - Orquestrar ambiente local com Docker Compose
   - Rationale: garante ambiente previsivel para desenvolvimento, testes e integracao com WAHA.

3. **Week 2, Days 1-2:** `STORY-003` - Implementar autenticacao JWT com contexto de familia
   - Rationale: desbloqueia o controle de acesso para todas as APIs de dominio.

4. **Week 2, Days 3-4:** `STORY-004` - Entregar API de criacao de familia e gestao basica de membros
   - Rationale: materializa o onboarding principal e habilita isolamento por familia.

5. **Week 2, Day 5:** `STORY-005` - Entregar cadastro inicial de bancos, contas e saldo inicial
   - Rationale: fecha a capacidade da sprint com o primeiro passo do dominio financeiro.

## Story Dependencies

### Dependency Graph

```text
STORY-001
  ├─> STORY-002
  └─> STORY-003
       └─> STORY-004
             └─> STORY-005
```

### Critical Path Stories

- `STORY-001` - bloqueia `STORY-002` e `STORY-003`
- `STORY-003` - bloqueia `STORY-004`
- `STORY-004` - bloqueia `STORY-005`

### External Dependencies

- Biblioteca JWT do Laravel: precisa ser fechada no inicio da `STORY-003`
- Configuracao funcional do WAHA em container: precisa estar operante ao fim da `STORY-002`

## Risks and Mitigation

### Risk 1: Escolha ou integracao da biblioteca JWT atrasar
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** decidir a biblioteca e o modelo de refresh no primeiro dia da implementacao de autenticacao
- **Contingency:** simplificar a primeira entrega para access token + refresh basico, deixando revogacao avancada para sprint seguinte

### Risk 2: Integracao Docker + WAHA exigir mais ajuste operacional que o previsto
- **Probability:** Medium
- **Impact:** Medium
- **Mitigation:** limitar a sprint ao bootstrap da stack e validar apenas o basico de comunicacao e health
- **Contingency:** manter WAHA operacionalmente isolado e seguir com backend/local stack, registrando pendencias menores para sprint seguinte

### Risk 3: Escopo de onboarding crescer para alem do necessario
- **Probability:** Medium
- **Impact:** Medium
- **Mitigation:** limitar `STORY-004` ao fluxo minimo de criar familia e membro inicial
- **Contingency:** mover convites mais sofisticados para backlog

## Sprint Milestones

- **Day 3:** `STORY-001` concluida e stack local em andamento
- **Day 6:** `STORY-002` concluida e base pronta para autenticacao
- **Day 8:** `STORY-003` concluida
- **Day 9:** `STORY-004` concluida
- **Day 10:** `STORY-005` concluida e sprint goal atingido

## Definition of Done

A story e considerada pronta quando:
- [ ] Todos os acceptance criteria da historia forem atendidos
- [ ] Codigo revisado e aprovado
- [ ] Testes relevantes escritos e passando
- [ ] Contratos e documentacao tecnica atualizados quando necessario
- [ ] Configuracoes e variaveis de ambiente documentadas
- [ ] Integracao validada no ambiente local da sprint

## Sprint Ceremonies

### Daily Standups
- **Duration:** 15 minutos
- **Format:** ontem, hoje e bloqueios

### Sprint Review
- **Date:** 2026-05-01
- **Duration:** 1 hora
- **Purpose:** demonstrar a fundacao tecnica, autenticacao e onboarding administrativo inicial

### Sprint Retrospective
- **Date:** 2026-05-01
- **Duration:** 1 hora
- **Purpose:** calibrar estimativas, fluxo de implementacao e acoplamentos entre backend, Docker e WAHA

### Sprint Planning (Next Sprint)
- **Date:** 2026-05-01 ou proximo dia util
- **Duration:** 1-2 horas
- **Purpose:** planejar a primeira sprint focada em operacao financeira e WhatsApp

## Success Criteria

Esta sprint sera considerada bem-sucedida se:
1. o backend modular estiver operacional com convencoes basicas definidas;
2. a stack local subir de forma reproduzivel com Docker Compose;
3. a autenticacao JWT e o escopo por familia estiverem funcionais;
4. o administrador conseguir criar a familia e a estrutura financeira minima por API;
5. nao houver bloqueio arquitetural relevante para iniciar historias de ledger e WhatsApp na sprint seguinte.

## Burndown Tracking

| Date | Completed | Remaining | Ideal Remaining | Notes |
|------|-----------|-----------|-----------------|-------|
| 2026-04-17 | 0 | 20 | 20 | Sprint iniciada |
| 2026-04-21 | 3 | 17 | 16 | Estrutura modular concluida |
| 2026-04-24 | 8 | 12 | 10 | Docker Compose e stack local estabilizados |
| 2026-04-28 | 13 | 7 | 6 | JWT concluido |
| 2026-05-01 | 20 | 0 | 0 | Sprint concluida |

## Team Capacity

### Team Members

- **Developer 1:** capacidade principal desta sprint, 10 dev-days estimados

**Total Developer-Days:** 10 dias

### Capacity Adjustments

- **Holidays:** nao registrados
- **PTO:** nao registrado
- **Meetings:** absorvidos no fator conservador de 2 pontos por dia
- **Support/On-call:** nao considerado neste primeiro planejamento

## Backlog Sugerido para Sprint Seguinte

1. `STORY-006` - consulta de saldo consolidado por API (3 points)
2. `STORY-007` - lancamento manual de despesa e receita (5 points)
3. `STORY-008` - recepcao de webhook WAHA com idempotencia (5 points)
4. `STORY-009` - fluxo guiado de consulta de saldo via WhatsApp (5 points)
5. `STORY-010` - historico e auditoria de lancamentos (3 points)

## Notes

- O plano assume um primeiro sprint de fundacao, sem tentar entregar todo o canal conversacional cedo demais.
- O escopo foi mantido em 20 pontos para respeitar a capacidade configurada e evitar historias acima de 5 pontos.
- As historias foram decompostas para permitir que `bmad:create-story` gere artefatos detalhados a seguir, se desejado.

# Sprint Plan: Financeiro Familiar com WhatsApp e Vue

- **Sprint Number:** 3
- **Sprint Dates:** 2026-05-18 - 2026-05-29
- **Sprint Duration:** 2 semanas / 10 dias uteis
- **Created:** 2026-04-17

## Sprint Overview

**Sprint Goal:** entregar os primeiros fluxos guiados de lancamento via WhatsApp e a primeira superficie visual do frontend Vue para acesso e consulta de saldo.

**Sprint Capacity:** 20 story points  
**Stories Planned:** 4 stories  
**Total Story Points:** 18 points

**Capacity Calculation:**
- **Base capacity:** 20 pontos, mantida pela velocidade observada nas 2 primeiras sprints
- **Adjustments:** sem PTO, feriados ou suporte extra registrados; capacidade preservada em 20 pontos
- **Final capacity:** 20 pontos

## Velocity Metrics

**Historical Velocity:**
- Sprint 1: 20 pontos
- Sprint 2: 20 pontos
- **3-Sprint Average:** nao aplicavel ainda; usar media parcial de 20 pontos como referencia operacional

**Team Composition:**
- 1 desenvolvedor principal equivalente
- 10 dias uteis disponiveis nesta sprint
- Estimativa de 2 pontos por dev-day como taxa conservadora ja validada

## Sprint Backlog

### Epic 1: Fluxo guiado WhatsApp (10 points)

**Epic Goal:** permitir que membros autorizados lancem despesas e creditos pelo WhatsApp com conversa guiada, confirmacao e persistencia segura.

#### STORY-011: Fluxo guiado de registro de despesa via WhatsApp
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-009, STORY-006
- **Brief:** guiar o membro autorizado pela coleta e confirmacao de uma despesa antes de persistir o lancamento.

#### STORY-012: Fluxo guiado de registro de credito via WhatsApp
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-009, STORY-006
- **Brief:** guiar o membro autorizado pela coleta e confirmacao de um credito antes de persistir o lancamento.

---

### Epic 2: Frontend Vue inicial (8 points)

**Epic Goal:** disponibilizar a primeira entrada visual do produto com onboarding e visao de saldo, pronta para evoluir nas proximas sprints.

#### STORY-013: Painel Vue para login e onboarding inicial
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** Nenhuma
- **Brief:** criar a primeira tela de entrada do frontend com orientacao simples e responsiva para desktop e mobile.

#### STORY-014: Painel Vue para saldo consolidado e contas
- **Priority:** Must Have
- **Points:** 3
- **Status:** Not Started
- **Dependencies:** STORY-007, STORY-013
- **Brief:** exibir saldo consolidado e saldo por conta em um painel Vue enxuto e legivel.

---

## Story Prioritization

### Must Have (Critical Path)
Stories that must be completed to achieve sprint goal:
1. `STORY-011` - fluxo guiado de registro de despesa via WhatsApp (5 points)
2. `STORY-012` - fluxo guiado de registro de credito via WhatsApp (5 points)
3. `STORY-013` - painel Vue para login e onboarding inicial (5 points)
4. `STORY-014` - painel Vue para saldo consolidado e contas (3 points)

**Total Must Have:** 18 points

### Should Have (High Priority)
Importantes para o produto, mas nao incluidos neste compromisso de sprint:
1. Nenhuma historia `Should Have` foi incluida no compromisso atual.

**Total Should Have:** 0 points

### Could Have (Nice to Have)
Lower priority stories, may be deferred if needed:
1. Nenhuma historia `Could Have` foi comprometida nesta sprint.

**Total Could Have:** 0 points

## Implementation Order

Recommended sequence based on dependencies and priorities:

1. **Week 1, Days 1-2:** `STORY-013` - Painel Vue para login e onboarding inicial
   - Rationale: cria a base visual e de navegacao para o frontend antes da tela de saldo.

2. **Week 1, Days 2-4:** `STORY-011` - Fluxo guiado de registro de despesa via WhatsApp
   - Rationale: abre o principal fluxo transacional guiado do WhatsApp e valida o padrao de conversacao.

3. **Week 1, Days 4-6:** `STORY-012` - Fluxo guiado de registro de credito via WhatsApp
   - Rationale: reaproveita a mesma maquina de estados do fluxo de despesa e fecha o par de lancamentos basicos.

4. **Week 2, Days 1-3:** `STORY-014` - Painel Vue para saldo consolidado e contas
   - Rationale: completa a primeira superficie visual de consulta, ancorada no contrato de saldo ja existente.

## Story Dependencies

### Dependency Graph
```text
STORY-006
  └─> STORY-011
  └─> STORY-012

STORY-009
  └─> STORY-011
  └─> STORY-012

STORY-007
  └─> STORY-014

STORY-013
  └─> STORY-014
```

### Critical Path Stories
Stories on the critical path (blocking other work):
- `STORY-013` - blocks `STORY-014`
- `STORY-006` - blocks `STORY-011` and `STORY-012`
- `STORY-009` - blocks `STORY-011` and `STORY-012`
- `STORY-007` - blocks `STORY-014`

### External Dependencies
- WAHA local com webhook configuravel e estavel: precisa permanecer operacional para validar `STORY-011` e `STORY-012`
- Contrato de consulta de saldo do backend: precisa permanecer compativel para alimentar `STORY-014`
- Stack Vue existente no projeto: precisa estar disponivel para a tela inicial e o painel de saldo

## Risks and Mitigation

### Risk 1: Fluxos guiados no WhatsApp ficarem longos demais e quebrarem a experiencia
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** manter coleta de dados em passos curtos, com confirmacao final antes da persistencia
- **Contingency:** reduzir campos opcionais e adiar refinamentos de copy para a sprint seguinte

### Risk 2: Dependencia entre frontend e backend desacelerar a entrega da primeira tela Vue
- **Probability:** Medium
- **Impact:** Medium
- **Mitigation:** usar contratos ja existentes e tratar o frontend como superficie de leitura inicial, sem novas integracoes complexas
- **Contingency:** entregar `STORY-013` e `STORY-014` com dados mockados temporariamente, se necessario

### Risk 3: Escopo expandir para IA antes de estabilizar os fluxos basicos
- **Probability:** Low
- **Impact:** High
- **Mitigation:** manter `STORY-015` fora do compromisso da sprint
- **Contingency:** replanejar a historia apenas depois de concluir os fluxos de WhatsApp e a primeira base do frontend

## Sprint Milestones

- **Day 2:** `STORY-013` em andamento com base visual e responsividade inicial
- **Day 4:** `STORY-011` iniciada com coleta guiada e confirmacao definida
- **Day 6:** `STORY-012` iniciada ou finalizada, reutilizando a mesma maquina de estados
- **Day 8:** `STORY-014` em validacao com contrato de saldo
- **Day 10:** Sprint goal concluido com os 4 stories planejados entregues

## Definition of Done

A story e considerada pronta quando:
- [ ] Todos os acceptance criteria forem atendidos
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
- **Date:** 2026-05-29
- **Duration:** 1 hora
- **Purpose:** demonstrar os fluxos guiados de WhatsApp e a primeira tela Vue funcional

### Sprint Retrospective
- **Date:** 2026-05-29
- **Duration:** 1 hora
- **Purpose:** calibrar o equilibrio entre conversacao, ledger e frontend visual

### Sprint Planning (Next Sprint)
- **Date:** 2026-05-29 ou proximo dia util
- **Duration:** 1-2 horas
- **Purpose:** planejar a proxima extensao do fluxo guiado e a evolucao do frontend

## Success Criteria

Esta sprint sera considerada bem-sucedida se:
1. o sistema permitir registrar despesas e creditos por fluxo guiado no WhatsApp;
2. a primeira tela Vue de login e onboarding estiver funcional e responsiva;
3. o painel Vue de saldo consolidado e contas consumir o contrato de backend existente;
4. a sprint concluir com 18 pontos planejados entregues sem ultrapassar capacidade;
5. o backlog seguinte possa evoluir sem bloqueios estruturais nos contratos basicos.

## Burndown Tracking

Track remaining story points daily or every few days:

| Date | Completed | Remaining | Ideal Remaining | Notes |
|------|-----------|-----------|-----------------|-------|
| 2026-05-18 | 0 | 18 | 18 | Sprint begins |
| 2026-05-20 | 5 | 13 | 14 | Base do frontend ou primeiro fluxo guiado em progresso |
| 2026-05-23 | 10 | 8 | 10 | Metade do compromisso validada |
| 2026-05-26 | 15 | 3 | 4 | Apenas o ultimo item de integracao restante |
| 2026-05-29 | 18 | 0 | 0 | Sprint complete |

## Team Capacity

### Team Members
- **Developer 1:** capacidade principal da sprint, 10 dev-days disponiveis

**Total Developer-Days:** 10 dias

### Capacity Adjustments
- **Holidays:** nao registrados
- **PTO:** nao registrado
- **Meetings:** absorvidos no fator conservador de 2 pontos por dia
- **Support/On-call:** nao considerado

## Notes

- A Sprint 3 expande o foco do produto para o primeiro fluxo guiado real no WhatsApp e para a primeira superficie visual do frontend Vue.
- `STORY-015` continua fora do compromisso para evitar dispersao antes da estabilizacao dos fluxos basicos.
- A capacidade permanece em 20 pontos, mas o compromisso foi mantido em 18 pontos para deixar margem operacional.

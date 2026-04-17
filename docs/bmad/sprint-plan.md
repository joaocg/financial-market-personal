# Sprint Plan: Financeiro Familiar com WhatsApp

- **Sprint Number:** 2
- **Sprint Dates:** 2026-05-04 - 2026-05-15
- **Sprint Duration:** 2 semanas / 10 dias uteis
- **Created:** 2026-04-17

## Sprint Overview

**Sprint Goal:** entregar o primeiro ciclo operacional do produto, cobrindo motor financeiro basico no backend e o primeiro fluxo funcional de consulta via WhatsApp com webhook seguro e auditavel.

**Sprint Capacity:** 20 story points  
**Stories Planned:** 5 stories  
**Total Story Points:** 20 points

**Capacity Calculation:**
- **Base capacity:** 20 pontos, usando a velocity observada da Sprint 1
- **Adjustments:** sem PTO ou feriados registrados; mantida a mesma capacidade para preservar previsibilidade
- **Final capacity:** 20 pontos

## Velocity Metrics

**Historical Velocity:**
- Sprint anterior: 20 pontos
- **3-Sprint Average:** nao aplicavel

**Team Composition:**
- 1 desenvolvedor principal equivalente
- 10 dias uteis estimados nesta sprint
- 2 pontos por dev-day como taxa conservadora e ja validada pela Sprint 1

## Sprint Backlog

### Epic 1: Motor financeiro basico (10 points)

**Epic Goal:** permitir registrar movimentacoes financeiras manuais e consultar saldo consolidado com consistencia por familia e conta.

#### STORY-006: Implementar motor de lancamentos manuais de despesa e receita
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-005
- **Brief:** criar endpoints e regras de negocio para registrar despesas e creditos, atualizando o saldo corrente da conta e mantendo rastreabilidade do actor e do canal.

#### STORY-007: Expor consulta de saldo consolidado e por conta
- **Priority:** Must Have
- **Points:** 3
- **Status:** Not Started
- **Dependencies:** STORY-006
- **Brief:** disponibilizar API para saldo total da familia e saldo por conta, com payload simples para consumo futuro pelo frontend e pelo canal WhatsApp.

#### STORY-008: Registrar historico e auditoria basica de lancamentos
- **Priority:** Should Have
- **Points:** 2
- **Status:** Not Started
- **Dependencies:** STORY-006
- **Brief:** persistir trilha minima de auditoria para lancamentos manuais, incluindo tipo de evento, actor, contexto familiar e origem da operacao.

---

### Epic 2: WhatsApp operacional inicial (10 points)

**Epic Goal:** habilitar o primeiro fluxo conversacional util do MVP, com recepcao de webhook WAHA, validacao do remetente e resposta de consulta de saldo.

#### STORY-009: Receber webhook WAHA com idempotencia e autorizacao de membro
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-004
- **Brief:** criar endpoint de webhook, validar segredo, persistir evento bruto, garantir idempotencia e resolver o membro autorizado pelo contato recebido.

#### STORY-010: Entregar consulta de saldo via WhatsApp
- **Priority:** Must Have
- **Points:** 5
- **Status:** Not Started
- **Dependencies:** STORY-007, STORY-009
- **Brief:** interpretar a intencao basica de saldo, consultar o backend e responder pelo fluxo de mensagens com idioma e contexto do membro.

---

## Story Prioritization

### Must Have (Critical Path)

1. `STORY-006` - lancamentos manuais de despesa e receita (5 points)
2. `STORY-007` - consulta de saldo consolidado e por conta (3 points)
3. `STORY-009` - webhook WAHA com idempotencia e autorizacao (5 points)
4. `STORY-010` - consulta de saldo via WhatsApp (5 points)

**Total Must Have:** 18 pontos

### Should Have (High Priority)

1. `STORY-008` - historico e auditoria basica de lancamentos (2 points)

**Total Should Have:** 2 pontos

### Could Have (Nice to Have)

Nenhuma historia `Could Have` foi incluída nesta sprint para evitar sobrecarga antes de estabilizar `Ledger` e `Messaging`.

**Total Could Have:** 0 pontos

## Implementation Order

Recommended sequence based on dependencies and priorities:

1. **Week 1, Days 1-3:** `STORY-006` - Implementar motor de lancamentos manuais de despesa e receita
   - Rationale: estabelece o nucleo transacional do dominio e desbloqueia saldo, auditoria e uso conversacional.

2. **Week 1, Days 4-5:** `STORY-007` - Expor consulta de saldo consolidado e por conta
   - Rationale: transforma o ledger em capacidade consultavel e reaproveitavel por API e WhatsApp.

3. **Week 2, Day 1:** `STORY-008` - Registrar historico e auditoria basica de lancamentos
   - Rationale: fecha o minimo de auditabilidade exigido pelo PRD sem ampliar demais o escopo do ledger.

4. **Week 2, Days 2-3:** `STORY-009` - Receber webhook WAHA com idempotencia e autorizacao de membro
   - Rationale: prepara a entrada segura do canal conversacional e reduz risco operacional antes do fluxo de resposta.

5. **Week 2, Days 4-5:** `STORY-010` - Entregar consulta de saldo via WhatsApp
   - Rationale: materializa o primeiro fluxo util do canal WhatsApp com dependencia direta de saldo e webhook.

## Story Dependencies

### Dependency Graph

```text
STORY-005
  └─> STORY-006
       ├─> STORY-007
       │    └─> STORY-010
       └─> STORY-008

STORY-004
  └─> STORY-009
       └─> STORY-010
```

### Critical Path Stories

- `STORY-006` - bloqueia `STORY-007` e `STORY-008`
- `STORY-007` - bloqueia `STORY-010`
- `STORY-009` - bloqueia `STORY-010`
- `STORY-010` - representa a entrega final do sprint goal

### External Dependencies

- WAHA local com webhook configuravel e estavel: precisa permanecer operacional para validar `STORY-009` e `STORY-010`
- Estrategia JWT atual do backend: precisa permanecer compativel com o contexto autenticado existente para nao introduzir retrabalho no `Ledger`

## Risks and Mitigation

### Risk 1: Modelagem de ledger crescer alem do necessario para o MVP
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** limitar `STORY-006` a despesa, credito e atualizacao de saldo corrente sem categorias avancadas ou ajustes complexos
- **Contingency:** adiar cancelamento avancado e relatorios detalhados para a sprint seguinte

### Risk 2: WAHA exigir ajustes operacionais extras no fluxo de webhook
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** tratar `STORY-009` como entrega de infraestrutura funcional com persistencia de evento bruto e resposta minima
- **Contingency:** manter o parser de intencao de `STORY-010` simples e restringido a consulta de saldo

### Risk 3: Dependencias cruzadas entre `Ledger` e `Messaging` reduzirem throughput
- **Probability:** Medium
- **Impact:** Medium
- **Mitigation:** fechar contratos internos simples entre modulo de saldo e modulo de mensagens antes de iniciar `STORY-010`
- **Contingency:** usar DTOs e adaptadores internos sem antecipar generalizacoes de IA nesta sprint

## Sprint Milestones

- **Day 3:** `STORY-006` concluida e saldo por conta atualizado corretamente
- **Day 5:** `STORY-007` concluida e epic de consulta financeira parcialmente fechado
- **Day 6:** `STORY-008` concluida e auditabilidade minima assegurada
- **Day 8:** `STORY-009` concluida com webhook WAHA persistindo eventos idempotentes
- **Day 10:** `STORY-010` concluida e consulta de saldo via WhatsApp operacional

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
- **Date:** 2026-05-15
- **Duration:** 1 hora
- **Purpose:** demonstrar lancamentos manuais, consulta de saldo e o primeiro fluxo funcional no WhatsApp

### Sprint Retrospective
- **Date:** 2026-05-15
- **Duration:** 1 hora
- **Purpose:** calibrar throughput entre `Ledger`, `Messaging` e dependencias de ambiente

### Sprint Planning (Next Sprint)
- **Date:** 2026-05-15 ou proximo dia util
- **Duration:** 1-2 horas
- **Purpose:** planejar a sprint de fluxo guiado de lancamento via WhatsApp e primeiros passos de frontend Vue

## Success Criteria

Esta sprint sera considerada bem-sucedida se:
1. o sistema permitir registrar manualmente despesas e creditos com impacto correto no saldo;
2. a API responder saldo consolidado e por conta com escopo por familia;
3. o backend receber e persistir webhooks do WAHA com idempotencia e autorizacao minima;
4. um membro autorizado conseguir consultar saldo pelo WhatsApp com resposta valida;
5. o backlog seguinte possa focar em fluxo guiado de lancamento e frontend sem bloqueio estrutural.

## Burndown Tracking

| Date | Completed | Remaining | Ideal Remaining | Notes |
|------|-----------|-----------|-----------------|-------|
| 2026-05-04 | 0 | 20 | 20 | Sprint iniciada |
| 2026-05-06 | 5 | 15 | 16 | Motor financeiro entregue |
| 2026-05-08 | 8 | 12 | 12 | Consulta de saldo pronta |
| 2026-05-11 | 10 | 10 | 8 | Auditoria basica concluida |
| 2026-05-13 | 15 | 5 | 4 | Webhook WAHA estabilizado |
| 2026-05-15 | 20 | 0 | 0 | Sprint concluida |

## Team Capacity

### Team Members

- **Developer 1:** capacidade principal desta sprint, 10 dev-days estimados

**Total Developer-Days:** 10 dias

### Capacity Adjustments

- **Holidays:** nao registrados
- **PTO:** nao registrado
- **Meetings:** absorvidos no fator conservador de 2 pontos por dia
- **Support/On-call:** nao considerado

## Backlog Sugerido para Sprint Seguinte

1. `STORY-011` - fluxo guiado de registro de despesa via WhatsApp (5 points)
2. `STORY-012` - fluxo guiado de registro de credito via WhatsApp (5 points)
3. `STORY-013` - painel Vue para login e onboarding inicial (5 points)
4. `STORY-014` - painel Vue para saldo consolidado e contas (3 points)
5. `STORY-015` - ingestao inicial de imagem para assistencia por IA (5 points)

## Notes

- A Sprint 2 usa a velocity real de 20 pontos da Sprint 1 como referencia de capacidade.
- O escopo foi intencionalmente concentrado em `Ledger` e `Messaging`, que sao os proximos habilitadores diretos do MVP.
- O frontend Vue continua fora do sprint para evitar dispersao antes da validacao do primeiro fluxo WhatsApp realmente utilizavel.

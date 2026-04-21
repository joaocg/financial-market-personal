# Sprint Plan: Financeiro Familiar com WhatsApp - Sprint 4

- **Sprint Number:** 4
- **Sprint Dates:** 2026-04-17 - 2026-04-20
- **Sprint Duration:** 4 dias corridos
- **Created:** 2026-04-20

## Sprint Overview

**Sprint Goal:** operacionalizar o WAHA, fechar o onboarding administrativo no frontend e validar o fluxo ponta a ponta do WhatsApp ate o ledger.

**Sprint Capacity:** 20 story points  
**Stories Planned:** 4 stories  
**Total Story Points:** 18 points

**Capacity Calculation:**
- **Base capacity:** 20 pontos, mantendo a referencia observada nas sprints anteriores.
- **Adjustments:** preservada margem de 2 pontos para setup operacional, verificacoes locais e troubleshooting.
- **Final capacity:** 20 pontos

## Velocity Metrics

**Historical Velocity:**
- Sprint 1: 20 pontos
- Sprint 2: 20 pontos
- Sprint 3: 18 pontos
- **Rolling Average:** 19 pontos

**Team Composition:**
- 1 desenvolvedor principal equivalente
- execucao concentrada em um ciclo curto de estabilizacao e fechamento do MVP

## Sprint Backlog

### Epic 1: Operacao WAHA e onboarding conversacional (13 points)

**Epic Goal:** tornar o canal WhatsApp utilizavel de ponta a ponta, com configuracao repetivel, contato autorizado configuravel e validacao operacional objetiva.

#### STORY-016: Bootstrap operacional do WAHA com credenciais e sessao local
- **Priority:** Must Have
- **Points:** 5
- **Status:** Completed
- **Dependencies:** STORY-002, STORY-009
- **Brief:** consolidar credenciais, sessao local e smoke checks basicos para o ambiente WAHA.

#### STORY-018: Painel Vue para vincular contato WhatsApp de membros
- **Priority:** Must Have
- **Points:** 5
- **Status:** Completed
- **Dependencies:** STORY-004, STORY-013
- **Brief:** permitir que o administrador vincule o numero autorizado de cada membro pela interface.

#### STORY-019: Smoke test ponta a ponta do fluxo WAHA ate o ledger
- **Priority:** Should Have
- **Points:** 3
- **Status:** Completed
- **Dependencies:** STORY-016, STORY-018, STORY-011, STORY-012
- **Brief:** validar webhook, resolucao do membro, conversa guiada e impacto observavel no saldo.

### Epic 2: Frontend administrativo de estrutura financeira (5 points)

**Epic Goal:** remover dependencias de chamadas manuais para a configuracao basica da estrutura financeira.

#### STORY-017: Painel Vue para cadastro de bancos e contas
- **Priority:** Must Have
- **Points:** 5
- **Status:** Completed
- **Dependencies:** STORY-005, STORY-013
- **Brief:** criar bancos e contas diretamente pelo frontend autenticado.

## Stretch Backlog

#### STORY-015: Ingestao inicial de imagem para assistencia por IA
- **Priority:** Should Have
- **Points:** 8
- **Status:** Completed
- **Brief:** entregar pipeline OCR-first com fallback opcional de IA para comprovantes enviados no WhatsApp.

## Story Prioritization

### Must Have (Critical Path)
1. `STORY-016` - bootstrap operacional do WAHA com credenciais e sessao local (5 points)
2. `STORY-017` - painel Vue para cadastro de bancos e contas (5 points)
3. `STORY-018` - painel Vue para vincular contato WhatsApp de membros (5 points)

**Total Must Have:** 15 points

### Should Have (High Priority)
1. `STORY-019` - smoke test ponta a ponta do fluxo WAHA ate o ledger (3 points)

**Total Should Have:** 3 points

### Could Have (Nice to Have)
1. `STORY-015` - ingestao inicial de imagem para assistencia por IA (8 points, entregue como adicional)

## Implementation Order

1. `STORY-016` para estabilizar credenciais, sessao e diagnostico local do WAHA.
2. `STORY-017` para fechar o cadastro administrativo minimo de bancos e contas.
3. `STORY-018` para conectar o onboarding dos membros ao uso real do canal conversacional.
4. `STORY-019` para comprovar o fluxo completo entre WhatsApp e ledger.

## Story Dependencies

### Dependency Graph

```text
STORY-002
  └─> STORY-016

STORY-009
  └─> STORY-016

STORY-005
  └─> STORY-017

STORY-013
  └─> STORY-017
  └─> STORY-018

STORY-004
  └─> STORY-018

STORY-016
  └─> STORY-019

STORY-018
  └─> STORY-019

STORY-011
  └─> STORY-019

STORY-012
  └─> STORY-019
```

### Critical Path Stories
- `STORY-016` - desbloqueia a validacao operacional do canal WAHA
- `STORY-018` - desbloqueia a resolucao correta do membro no fluxo conversacional
- `STORY-019` - fecha a confianca do MVP integrado

## Risks and Mitigation

### Risk 1: Sessao WAHA ou credenciais locais falharem de forma opaca
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** concentrar configuracao, mensagens de erro e checks operacionais em um fluxo unico.

### Risk 2: Frontend administrativo nao refletir contratos do backend
- **Probability:** Medium
- **Impact:** Medium
- **Mitigation:** reutilizar endpoints existentes e validar estados de erro, sucesso e listagem com testes.

### Risk 3: Fluxo ponta a ponta passar isoladamente por modulo, mas falhar na integracao real
- **Probability:** Medium
- **Impact:** High
- **Mitigation:** padronizar smoke test com checkpoints claros em webhook, conversa e saldo final.

## Sprint Milestones

- **Milestone 1:** WAHA operacional com setup repetivel e diagnostico basico fechado
- **Milestone 2:** frontend administrativo cobrindo bancos, contas e contato WhatsApp do membro
- **Milestone 3:** smoke test ponta a ponta validado com impacto real no ledger

## Definition of Done

A sprint e considerada concluida quando:
- [x] Todas as historias comprometidas foram entregues
- [x] O canal WAHA pode ser configurado localmente sem conhecimento tacito
- [x] O frontend cobre a configuracao administrativa minima do MVP
- [x] O fluxo ponta a ponta foi validado com um roteiro repetivel
- [x] A documentacao BMAD e operacional foi atualizada

## Success Criteria

Esta sprint e considerada bem-sucedida se:
1. o WAHA puder ser inicializado e diagnosticado com passos objetivos;
2. o administrador conseguir cadastrar bancos, contas e o WhatsApp autorizado do membro pela interface;
3. o fluxo guiado do WhatsApp puder ser exercitado ate refletir saldo no ledger;
4. o MVP sair deste ciclo com backlog operacional critico resolvido.

## Notes

- A `STORY-015` foi entregue como incremento adicional no mesmo periodo, mas permaneceu fora do compromisso principal da sprint.
- Com a conclusao da Sprint 4, o BMAD nao aponta novas historias pendentes ate `STORY-019`.

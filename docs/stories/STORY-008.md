# Registrar historico e auditoria basica de lancamentos

- **ID:** STORY-008
- **Epic:** Motor financeiro basico
- **Priority:** Should Have
- **Story Points:** 2
- **Status:** Not Started

## User Story

As a **administrador da familia**
I want to **ter uma trilha minima de auditoria dos lancamentos financeiros**
So that **eu consiga saber quem fez cada operacao e por qual canal ela entrou**

## Acceptance Criteria

- [ ] **Criterion 1:** Cada lancamento manual registra actor, familia, tipo de evento e canal de origem.
- [ ] **Criterion 2:** Existe estrutura persistente minima para trilha de auditoria financeira.
- [ ] **Criterion 3:** A trilha de auditoria nao depende exclusivamente de logs efemeros da aplicacao.
- [ ] **Criterion 4:** O desenho permite futura extensao para cancelamento, eventos de conversa e correlacao.

## Technical Notes

### Implementation Approach

Adicionar tabela simples de auditoria ou evento financeiro desacoplada do modelo principal de transacao, com gravacao dentro do fluxo de aplicacao do `Ledger`. O objetivo e entregar rastreabilidade minima, nao ainda um sistema completo de event sourcing.

### Files/Modules Affected

- `laravel/app/Modules/Ledger/` - disparo e persistencia da auditoria
- `laravel/app/Modules/Shared/` - possivel suporte comum para actor/contexto
- `laravel/database/migrations/` - tabela de auditoria basica
- `laravel/tests/Feature/Ledger/` - testes de persistencia de evento

### Data Model Changes

- criar tabela `audit_logs` ou `ledger_audit_logs`
- campos minimos: `family_id`, `transaction_id`, `event_type`, `actor_id`, `origin_channel`, `metadata`, `created_at`

### API Changes

- nenhuma rota publica obrigatoria nesta historia
- a auditoria e efeito colateral obrigatorio do fluxo de lancamento

### Edge Cases

- **Actor nulo em eventos de sistema futuros:** deixar a modelagem preparada para isso.
- **Falha na gravacao da auditoria:** deve impedir a confirmacao do lancamento se a consistencia transacional for requerida.
- **Metadata opcional:** suportar JSON vazio sem quebrar a persistencia.

### Performance Considerations

Registrar auditoria no mesmo fluxo transacional, com payload enxuto, evitando salvar blobs ou estruturas pesadas.

### Security Considerations

- a trilha nao deve expor segredos nem payloads sensiveis desnecessarios
- metadata deve ser serializada com cuidado

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-006` - a auditoria depende de um fluxo de lancamento existente
- **Blocks:** nenhuma historia de bloqueio direto, mas reduz risco para as proximas fases

### Technical Dependencies

- transacoes do modulo `Ledger`
- identificacao consistente do usuario autenticado
- politica minima para campo `origin_channel`

### Open Questions

- [ ] A nomenclatura padrao sera `audit_logs` compartilhada ou uma tabela especifica do modulo `Ledger`?
- [ ] Quais campos minimos entram em `metadata` nesta primeira iteracao?

## Testing Requirements

### Unit Tests

- [ ] Validar montagem do payload de auditoria para despesa
- [ ] Validar montagem do payload de auditoria para credito
- [ ] Validar serializacao de metadata

### Integration Tests

- [ ] Registrar lancamento e confirmar a criacao de trilha de auditoria
- [ ] Confirmar que actor e canal de origem foram persistidos

### Manual Testing

- [ ] Criar movimentacao e inspecionar a linha de auditoria no banco
- [ ] Conferir se a auditoria preserva o `family_id` correto

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

Esta historia materializa a base de `FR-013` e `NFR-006` para o dominio financeiro antes da entrada do canal conversacional.

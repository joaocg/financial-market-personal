# Bootstrap operacional do WAHA com credenciais e sessao local

- **ID:** STORY-016
- **Epic:** Operacao WAHA e onboarding conversacional
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed
- **Completed Date:** 2026-04-17

## User Story

As a **responsavel tecnico pelo ambiente**
I want to **configurar WAHA, credenciais e sessao local com um fluxo documentado e verificavel**
So that **o canal WhatsApp do MVP funcione sem setup manual disperso**

## Acceptance Criteria

- [x] **Criterion 1:** Existe documentacao objetiva para configurar `WAHA_BASE_URL`, `WAHA_API_KEY` e `WAHA_WEBHOOK_SECRET` no ambiente local.
- [x] **Criterion 2:** O fluxo de inicializacao da sessao WAHA fica descrito com os passos minimos para conectar o numero e validar persistencia.
- [x] **Criterion 3:** Existe pelo menos um smoke check manual ou automatizado para confirmar que o webhook do backend recebe eventos do WAHA.
- [x] **Criterion 4:** Falhas de credencial, segredo ou sessao invalida sao identificaveis por mensagens e logs compreensiveis.
- [x] **Criterion 5:** O setup local pode ser repetido por outra pessoa sem depender de conhecimento tacito.

## Technical Notes

### Implementation Approach

Consolidar a configuracao operacional do WAHA no repositorio, incluindo variaveis de ambiente, sessao local persistente e um passo a passo curto para bootstrap. O objetivo nao e sofisticar a integracao, e sim torna-la repetivel e segura para desenvolvimento e homologacao local.

### Files/Modules Affected

- `docker-compose.yml`
- `laravel/.env.example`
- `laravel/config/services.php` ou equivalente, se ajustes forem necessarios
- `laravel/README.md` ou documentacao operacional principal
- scripts auxiliares de bootstrap ou health check, se necessario

### Data Model Changes

- nenhuma mudanca obrigatoria

### API Changes

- nenhuma mudanca de contrato externo obrigatoria
- pode incluir endpoint interno ou script de smoke check, se isso reduzir ambiguidade operacional

### Edge Cases

- **Credencial ausente:** orientar erro claro sem falha silenciosa.
- **Sessao WAHA expirada ou desconectada:** indicar procedimento de reconexao.
- **Webhook com segredo incorreto:** permitir diagnostico rapido por log e resposta controlada.

### Performance Considerations

Priorizar bootstrap confiavel e resposta rapida do webhook antes de qualquer otimização adicional.

### Security Considerations

- nao versionar segredos reais
- documentar placeholders seguros
- evitar exposicao acidental de credenciais no frontend ou em logs desnecessarios

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-002` - a stack local com WAHA ja precisa existir
- **Blocked by:** `STORY-009` - o webhook WAHA ja precisa estar implementado
- **Blocks:** `STORY-019` - o smoke test ponta a ponta depende do bootstrap operacional concluido

### Technical Dependencies

- container WAHA operacional no Compose
- webhook Laravel disponivel em `/api/v1/webhooks/waha`
- leitura correta de credenciais via config/services

### Open Questions

- [ ] A conexao local usara sessao unica por ambiente ou multiplas sessoes no futuro?
- [ ] O bootstrap do QR code sera manual assistido ou encapsulado em script/documentacao com health checks?

## Testing Requirements

### Unit Tests

- [x] Validar leitura segura das configuracoes WAHA, se houver logica nova de configuracao

### Integration Tests

- [x] Validar envio de requisicao autenticada do WAHA para o webhook local
- [x] Validar comportamento quando o segredo do webhook estiver incorreto

### Manual Testing

- [x] Subir a stack local com WAHA
- [x] Conectar a sessao do WhatsApp
- [x] Confirmar que um evento chega ao webhook do backend

## Definition of Done

This story is considered complete when:

- [x] Code is written and follows project coding standards
- [x] All acceptance criteria are met and verified
- [x] Unit tests are written and passing (>80% coverage for new code)
- [x] Integration tests are written and passing (if applicable)
- [ ] Code has been reviewed and approved by at least one team member
- [x] No critical or high-priority bugs remain
- [x] Documentation is updated (README, API docs, inline comments)
- [ ] Changes are merged to main/development branch
- [x] Deployed to local development environment
- [ ] Product owner has reviewed and accepted the story

## Notes

Esta historia fecha a principal lacuna operacional do modulo de mensagens: sair de uma integracao correta em codigo para uma integracao utilizavel no ambiente real do time.

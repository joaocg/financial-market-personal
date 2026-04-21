# Painel Vue para vincular contato WhatsApp de membros

- **ID:** STORY-018
- **Epic:** Operacao WAHA e onboarding conversacional
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Completed

## User Story

As a **administrador da familia**
I want to **cadastrar ou atualizar o numero WhatsApp autorizado de um membro**
So that **o fluxo conversacional reconheca corretamente quem esta enviando mensagens**

## Acceptance Criteria

- [x] **Criterion 1:** O frontend permite informar ou atualizar o numero WhatsApp de um membro no contexto da familia.
- [x] **Criterion 2:** O numero e persistido em formato compativel com a normalizacao usada pelo backend.
- [x] **Criterion 3:** O painel deixa claro qual contato sera usado para autorizacao no WAHA.
- [x] **Criterion 4:** Erros de formato, duplicidade ou ausencia de membro sao exibidos de forma compreensivel.
- [x] **Criterion 5:** O fluxo resultante permite que o backend resolva o contato autorizado sem ajuste manual no banco.

## Technical Notes

### Implementation Approach

Expor no frontend a gestao minima de `member_contacts` para telefone WhatsApp, reaproveitando o modelo ja existente no backend. O objetivo e fechar o gap entre criacao do membro e uso real do canal conversacional.

### Files/Modules Affected

- `laravel/resources/js/` ou equivalente do frontend Vue
- `laravel/app/Modules/Families/Interfaces/Http/Controllers/` se for necessario expor endpoint de atualizacao
- `laravel/tests/Feature/Families/` ou equivalente
- `laravel/tests/Feature/Frontend/` e testes do frontend Vue

### Data Model Changes

- nenhuma mudanca obrigatoria se `member_contacts` ja atender ao fluxo
- aceitar ajuste pequeno de constraints ou indice se a historia expuser lacunas de integridade

### API Changes

- reutilizar `POST /api/v1/families/{familyId}/members` quando apropriado para criacao
- adicionar endpoint de atualizacao de contato do membro se a API atual nao suportar manutencao posterior

### Edge Cases

- **Numero em formato livre:** normalizar antes de persistir.
- **Membro sem contato anterior:** permitir cadastro inicial.
- **Numero ja usado por outro membro da mesma familia:** decidir regra e retornar mensagem segura.

### Performance Considerations

Baixa complexidade; priorizar confiabilidade da resolucao do contato sobre qualquer otimização prematura.

### Security Considerations

- garantir escopo por familia
- evitar exposicao de contatos de outros membros alem do necessario para administracao
- registrar alteracoes relevantes em trilha auditavel, se o modulo atual ja suportar isso

## Dependencies

### Story Dependencies

- **Blocked by:** `STORY-004` - membros e contatos base precisam existir
- **Blocked by:** `STORY-013` - frontend autenticado e contexto visual base precisam existir
- **Blocks:** `STORY-019` - o fluxo ponta a ponta depende de um contato autorizado corretamente vinculado

### Technical Dependencies

- `member_contacts` existente no backend
- rotina de normalizacao de telefone no modulo compartilhado
- resolucao de contato autorizado no modulo `Families`

### Open Questions

- [ ] O painel deve permitir apenas um WhatsApp primario por membro nesta iteracao?
- [ ] O contato sera editado em tela propria ou dentro da area de membros/onboarding?

## Testing Requirements

### Unit Tests

- [x] Validar normalizacao do numero antes do envio ou na resposta da API
- [x] Validar exibicao do estado atual do contato

### Integration Tests

- [x] Atualizar contato WhatsApp de um membro e confirmar persistencia
- [x] Validar que contato invalido ou duplicado retorna erro tratavel

### Manual Testing

- [x] Selecionar um membro
- [x] Informar numero WhatsApp valido
- [x] Enviar mensagem pelo numero configurado e confirmar reconhecimento do membro

## Definition of Done

This story is considered complete when:

- [x] Code is written and follows project coding standards
- [x] All acceptance criteria are met and verified
- [x] Unit tests are written and passing (>80% coverage for new code)
- [x] Integration tests are written and passing (if applicable)
- [x] Code has been reviewed and approved by at least one team member
- [x] No critical or high-priority bugs remain
- [x] Documentation is updated (README, API docs, inline comments)
- [x] Changes are merged to main/development branch
- [x] Deployed to local development environment
- [x] Product owner has reviewed and accepted the story

## Notes

Esta historia conecta onboarding administrativo e operacao do WhatsApp, eliminando um ponto de configuracao que hoje tende a ficar escondido no backend ou no banco.

## Delivery Notes

- A interface Vue agora lista os membros da familia e permite atualizar o WhatsApp autorizado de cada um.
- O numero e normalizado antes da persistencia e duplicidades na mesma familia retornam erro tratavel.
- O painel mostra o contato atual do membro selecionado para deixar claro qual numero o WAHA usara.
- O backend ganhou listagem de membros da familia e atualizacao segura do contato WhatsApp.

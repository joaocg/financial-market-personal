# Painel Vue para vincular contato WhatsApp de membros

- **ID:** STORY-018
- **Epic:** Operacao WAHA e onboarding conversacional
- **Priority:** Must Have
- **Story Points:** 5
- **Status:** Draft

## User Story

As a **administrador da familia**
I want to **cadastrar ou atualizar o numero WhatsApp autorizado de um membro**
So that **o fluxo conversacional reconheca corretamente quem esta enviando mensagens**

## Acceptance Criteria

- [ ] **Criterion 1:** O frontend permite informar ou atualizar o numero WhatsApp de um membro no contexto da familia.
- [ ] **Criterion 2:** O numero e persistido em formato compativel com a normalizacao usada pelo backend.
- [ ] **Criterion 3:** O painel deixa claro qual contato sera usado para autorizacao no WAHA.
- [ ] **Criterion 4:** Erros de formato, duplicidade ou ausencia de membro sao exibidos de forma compreensivel.
- [ ] **Criterion 5:** O fluxo resultante permite que o backend resolva o contato autorizado sem ajuste manual no banco.

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

- [ ] Validar normalizacao do numero antes do envio ou na resposta da API
- [ ] Validar exibicao do estado atual do contato

### Integration Tests

- [ ] Atualizar contato WhatsApp de um membro e confirmar persistencia
- [ ] Validar que contato invalido ou duplicado retorna erro tratavel

### Manual Testing

- [ ] Selecionar um membro
- [ ] Informar numero WhatsApp valido
- [ ] Enviar mensagem pelo numero configurado e confirmar reconhecimento do membro

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

Esta historia conecta onboarding administrativo e operacao do WhatsApp, eliminando um ponto de configuracao que hoje tende a ficar escondido no backend ou no banco.

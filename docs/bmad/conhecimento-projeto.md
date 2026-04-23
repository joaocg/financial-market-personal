# Entendimento do Projeto: Financeiro Familiar com WhatsApp

Este documento registra o entendimento técnico consolidado do projeto para servir como referência e garantir a continuidade do desenvolvimento.

## 1. Visão Geral
Sistema de gestão financeira para famílias que permite o controle de contas, saldos e lançamentos através de uma interface Web (Vue 3) e interações conversacionais via WhatsApp (WAHA).

## 2. Arquitetura Técnica

### Provedores e Serviços (Docker)
- **app**: Backend Laravel (PHP 8.x + Nginx).
- **worker**: Processador de filas Laravel (Redis).
- **mysql**: Banco de dados relacional.
- **redis**: Cache e drivers de fila.
- **waha**: Gateway de API para WhatsApp (NestJS).

### Estrutura do Backend (Modular DDD)
O projeto utiliza uma estrutura modular em `laravel/app/Modules/`:
- **Families**: Entidades de `Family` e `FamilyMembership`. Permite que um gestor gerencie membros.
- **Banking**: Gestão de `Bank` e `BankAccount` (Saldo inicial e atual).
- **Ledger**: Gestão de `Transaction` (Receitas e Despesas categorizadas).
- **Messaging**: Integração com WAHA.
    - `WahaWebhookController`: Recebe eventos do WhatsApp.
    - `HandleIncomingWahaMessageAction`: Orquestra a resposta baseada na intenção.
- **AI**: Processamento de imagens (comprovantes) e NLP para extração de dados.
- **Identity**: Gestão de usuários e autenticação.

## 3. Fluxos de Trabalho Implementados

### Interface Web
- Cadastro de famílias, bancos e contas.
- Visualização de painéis e lançamentos manuais.

### Interface WhatsApp (Conversacional)
O sistema utiliza um motor de intenções (`DetectMessageIntentAction`) para processar mensagens:
1. **Consulta de Saldo (`INTENT_BALANCE`)**: Retorna o saldo consolidado ou por conta.
2. **Lançamento de Despesa (`INTENT_EXPENSE`)**: Inicia fluxo de registro de gasto.
3. **Lançamento de Receita (`INTENT_CREDIT`)**: Inicia fluxo de registro de entrada.
4. **Processamento de Comprovantes**: Detecta anexos de imagem, envia para análise de IA (`RequestReceiptAnalysisAction`) e solicita confirmação do usuário.

## 4. Pontos de Atenção e Continuidade
- **Sessões de Conversa**: Gerenciadas via `ConversationSession` para manter o estado entre múltiplas mensagens no WhatsApp.
- **Idiomas**: Suporte a múltiplos idiomas por membro da família.
- **Últimas Despesas**: Funcionalidade mencionada no escopo que deve ser integrada ao fluxo de mensagens.

---
**Data de Registro:** 2026-04-21
**Referência:** `8a29eba7-b709-4593-9763-d9fda258bd97`

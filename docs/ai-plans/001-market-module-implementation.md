# AI Plan - 001 - Módulo de Mercado e Otimização de Compras

## 1. Business Context

O usuário necessita de um sistema para gerenciar preços de produtos em diferentes supermercados de forma colaborativa (crowdsourcing). O objetivo é permitir que uma equipe ou os próprios usuários cadastrem produtos (com apoio da API OpenFoodFacts) e registrem preços através de fotos de etiquetas, processadas por IA. Com esses dados, o sistema deve sugerir o melhor local (menor custo) para realizar uma lista de compras completa e analisar tendências de preços (altas e baixas) ao longo de um ano.

## 2. Authorization and Scope

> [!IMPORTANT]
> **AUTORIZAÇÃO EXPLÍCITA**: O usuário autorizou explicitamente a criação do novo módulo `Market` com classes, rotas, migrations, modelos e contratos novos. 
> A regra de "não inventar classes/métodos" do `AGENTS.md` fica suspensa **exclusivamente** para o escopo do novo diretório `laravel/app/Modules/Market` e arquivos de suporte (migrations, rotas específicas) necessários para esta task.
> **SEGURANÇA**: É estritamente proibido alterar a lógica ou o schema dos módulos financeiros existentes (`Ledger`, `Banking`, `Families`).

## 3. Current Behavior

O sistema atual foca em gestão financeira familiar (contas, saldos, despesas, receitas) via interface Web (Vue 3) e WhatsApp (WAHA). Já possui um módulo de IA para processamento de comprovantes de pagamento (recibos), mas não possui funcionalidades voltadas para comparação de preços de itens de mercado ou integração com APIs de produtos alimentícios.

## 4. Expected Behavior

- **Módulo Market**: Novo módulo modular DDD em `laravel/app/Modules/Market`.
- **Integração OpenFoodFacts**: Busca de metadados de produtos isolada em `Market/Infrastructure/ExternalServices`.
- **Coleta via IA**: Processamento de fotos de etiquetas via `AI` module ou novo handler no `Market`.
- **Validação Social**: Status `VERIFIED`, `DOUBTFUL`, `FALSE` para preços.
- **Otimização**: Cálculo de custo total de lista de compras.
- **Histórico**: Retenção e análise de 1 ano.

## 5. Affected Files

- `laravel/app/Modules/Market/*`: [NEW] Toda a estrutura do novo módulo.
- `laravel/database/migrations/*_create_market_tables.php`: [NEW] Novas tabelas.
- `laravel/app/Modules/Messaging/Application/DetectMessageIntent/DetectMessageIntentAction.php`: [MODIFY] Novo intent.
- `laravel/app/Modules/Messaging/Application/HandleIncomingWahaMessage/HandleIncomingWahaMessageAction.php`: [MODIFY] Handler de roteamento.

## 6. Existing Pattern to Reuse

- **Modular DDD**: Estrutura `Application`, `Domain`, `Infrastructure`, `Interfaces`.
- **Actions & DTOs**: Seguir o padrão de `AGENTS.md` para lógica em Actions e dados via DTOs.
- **AI patterns**: Jobs assíncronos e análise multimodal.

## 7. Implementation Steps

1. **Scaffold**: Criar diretório `laravel/app/Modules/Market` e subpastas.
2. **Database**: Criar migração para `products`, `establishments`, `price_entries`, `shopping_lists` e `shopping_list_items`.
3. **Infrastructure**: Criar Eloquent models e `OpenFoodFactsClient`.
4. **Application**: Criar DTOs e Actions (`RegisterProductAction`, `OptimizeShoppingListAction`, etc.).
5. **Messaging**: Adicionar intent e fluxo de conversa para coleta de preços.
6. **AI**: Implementar ação de análise de etiquetas.

## 8. Tests

- **Unitários**: Otimização de lista.
- **Integração**: Fluxo WhatsApp -> IA -> Database.

## 9. Risks

- **Quebra de Escopo**: Risco de alterar o sistema financeiro legado. *Mitigação*: Focar alterações apenas no novo módulo.
- **Falsa Positividade da IA**: *Mitigação*: Sistema de votos comunitários.

## 10. Git and Merge Request

Suggested branch name: `001-implement-market-module-crowdsourcing`
Suggested commit message: `001 - Implement market module with crowdsourcing and AI price extraction`
Suggested MR title: `001 - Implement market module with crowdsourcing and AI price extraction`

Suggested MR description in pt_BR:
## Objetivo
Implementar o novo módulo de Mercado com suporte a crowdsourcing e IA, conforme autorizado explicitamente pelo usuário.

## 11. Prompt for Codex

Leia `AGENTS.md`, `CODEX.md` e `AI-HARNESS.md`.
Leia o plano em `docs/ai-plans/001-market-module-implementation.md`.
**IMPORTANTE**: O usuário autorizou explicitamente a criação de novas classes, rotas, migrations e contratos para o novo módulo `Market`. Ignore a restrição de "não inventar" apenas para este novo diretório.
Implemente a estrutura inicial (Migrations e Models) do módulo `Market`.
Não altere nada nos módulos financeiros existentes.
Reporte os arquivos alterados e sugira o commit message padrão.

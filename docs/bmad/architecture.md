# System Architecture: Financeiro Familiar com WhatsApp

- **Document Version:** 0.1
- **Date:** 2026-04-17
- **Author:** Codex + Joao Coelho
- **Status:** Draft

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Architecture Pattern](#2-architecture-pattern)
3. [Component Design](#3-component-design)
4. [Data Model](#4-data-model)
5. [API Specifications](#5-api-specifications)
6. [Non-Functional Requirements Mapping](#6-non-functional-requirements-mapping)
7. [Technology Stack](#7-technology-stack)
8. [Trade-off Analysis](#8-trade-off-analysis)
9. [Deployment Architecture](#9-deployment-architecture)
10. [Future Considerations](#10-future-considerations)

---

## 1. System Overview

### Purpose

O sistema `Financeiro` existe para centralizar a operacao financeira familiar em uma plataforma unica, permitindo configuracao administrativa via frontend web e operacao de consultas e lancamentos por WhatsApp.

### Scope

**In Scope:**
- onboarding de familia, membros e papeis;
- autenticacao JWT para frontend Vue e APIs;
- cadastro de bancos, contas e saldo inicial;
- lancamentos de receita, despesa, ajuste e consulta de saldo;
- recepcao de webhooks do WAHA e envio de respostas conversacionais;
- processamento assíncrono para auditoria, imagens e assistencia por IA;
- execucao local previsivel via Docker.

**Out of Scope:**
- open banking e conciliacao bancaria automatica;
- multiempresa ou estrutura corporativa;
- persistencia automatica sem confirmacao humana para inferencias de IA;
- relatorios financeiros avancados e previsoes no MVP.

### Architectural Drivers

1. **NFR-001: Seguranca de autenticacao**  
Exige JWT, protecao de segredos, validacao de webhook e isolamento por familia.

2. **NFR-005: Confiabilidade de processamento**  
Exige idempotencia em webhooks, filas para tarefas lentas e trilha de auditoria.

3. **NFR-007: Modularidade e manutenibilidade**  
Exige backend organizado em `laravel/app/Modules` com fronteiras claras e baixo acoplamento.

4. **NFR-009: Portabilidade de ambiente**  
Exige stack executavel com Docker Compose e bootstrap previsivel do ambiente local.

5. **FR-009 a FR-012: Conversas WhatsApp e assistencia inteligente**  
Exigem integracao externa com WAHA, maquina de estados de conversa e processamento assíncrono.

### Stakeholders

- **Users:** administrador da familia e membros operacionais que usam web e WhatsApp.
- **Developers:** equipe pequena, com necessidade de produtividade alta e deploy simples.
- **Operations:** operacao inicialmente leve, com foco em ambiente local e futura homologacao simples.
- **Business:** responsavel financeiro da familia, que precisa de confiabilidade e rastreabilidade.

---

## 2. Architecture Pattern

### Selected Pattern

**Pattern:** Modular Monolith com integrações externas orientadas a eventos e jobs assíncronos.

### Pattern Justification

**Why this pattern:**
- O projeto e nivel 2 e possui dominio suficiente para separar responsabilidades, mas ainda nao justifica a complexidade operacional de microservices.
- O time tende a ser pequeno, entao um deploy unico do backend Laravel reduz custo cognitivo e operacional.
- A necessidade de `app/Modules` ja aponta para um monolito modular como equilibrio entre simplicidade e evolucao.
- O canal WhatsApp e o frontend Vue exigem contratos claros, mas nao exigem servicos independentes neste momento.

**Alternatives considered:**
- **Monolith tradicional:** rejeitado porque nao protege bem fronteiras de dominio e favorece acoplamento rapido.
- **Microservices:** rejeitado porque adiciona custo excessivo de observabilidade, deploy e consistencia distribuida para o MVP.
- **Serverless completo:** rejeitado porque o dominio principal depende de estado conversacional, jobs e integracao continua com stack Laravel.

### Pattern Application

O backend Laravel roda como um unico deploy, mas separado por modulos de dominio e por camadas internas:

- `Domain`: regras de negocio e entidades ricas;
- `Application`: casos de uso, DTOs e orquestracao;
- `Infrastructure`: persistencia, clients externos e implementacoes concretas;
- `Interfaces`: controllers HTTP, console commands, webhook handlers e jobs.

Estrutura recomendada:

```text
laravel/app/Modules/
  Identity/
    Domain/
    Application/
    Infrastructure/
    Interfaces/Http/
  Families/
  Banking/
  Ledger/
  Messaging/
  AI/
  Shared/
```

O frontend Vue permanece desacoplado como cliente externo. O WAHA permanece como servico de transporte e nao faz parte do dominio interno do produto.

---

## 3. Component Design

### Component Overview

```text
┌──────────────────────────────────────────────────────────────────────┐
│                            Client Layer                             │
│  Vue Web App                   WhatsApp User                        │
└───────────────┬───────────────────────────────┬──────────────────────┘
                │                               │
                │ HTTPS REST                    │ WhatsApp Messages
                │                               │
┌───────────────▼───────────────────────────────▼──────────────────────┐
│                      Laravel API / Webhook Layer                     │
│  Auth Controllers | Family Controllers | Ledger Controllers          │
│  WAHA Webhook Controller | Health Endpoints                          │
└───────────────┬───────────────────────────────┬──────────────────────┘
                │                               │
                │ in-process module calls       │ webhook / API client
                │                               │
┌───────────────▼───────────────────────────────▼──────────────────────┐
│                        Application Modules                           │
│ Identity | Families | Banking | Ledger | Messaging | AI | Shared    │
└───────────────┬───────────────────────┬──────────────────────────────┘
                │                       │
                │ sync writes/reads     │ async jobs/events
                │                       │
┌───────────────▼───────────────┐   ┌───▼──────────────────────────────┐
│ MySQL                         │   │ Queue Workers                    │
│ familias, membros, contas,    │   │ processa webhook, midia, IA,     │
│ lancamentos, conversas        │   │ notificacoes e retries           │
└───────────────┬───────────────┘   └───┬──────────────────────────────┘
                │                       │
                │                       │
        ┌───────▼────────┐       ┌──────▼───────────────┐
        │ Redis          │       │ External Services    │
        │ cache + queue  │       │ WAHA | IA | storage  │
        └────────────────┘       └──────────────────────┘
```

### Component Descriptions

#### Component: Vue Web App

**Responsibility:** oferecer a interface administrativa e operacional para onboarding, cadastros, consulta e auditoria.

**Interfaces Provided:**
- navegador do usuario;
- rotas SPA para login, dashboard, membros, bancos, contas e lancamentos.

**Interfaces Required:**
- `REST /api/v1/*` do backend Laravel;
- autenticacao JWT com refresh controlado;
- endpoint de health/config para bootstrap da aplicacao.

**Data Owned:**
- nenhum dado persistente de negocio;
- estado temporario de interface e token seguro no cliente.

**Key Operations:**
1. login e renovacao de sessao;
2. CRUD administrativo;
3. consulta de saldo e historico;
4. tratamento de erros de validacao e autorizacao.

**NFRs Addressed:**
- `NFR-008`: experiencia consistente e poucos passos;
- `NFR-009`: separacao clara entre frontend e backend.

---

#### Component: Identity Module

**Responsibility:** autenticar usuarios, emitir JWT, gerenciar perfil, papeis e autorizacao por familia.

**Interfaces Provided:**
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- middleware de autenticacao e policies por modulo

**Interfaces Required:**
- repositorio de usuarios e memberships;
- Redis opcional para blacklist ou controle de refresh;
- hashing e configuracao de segredos.

**Data Owned:**
- `users`
- `family_memberships`
- `refresh_tokens` ou estrutura equivalente

**Key Operations:**
1. autenticar credenciais;
2. emitir access token e refresh token;
3. resolver contexto de familia do usuario;
4. negar acesso fora do escopo autorizado.

**NFRs Addressed:**
- `NFR-001`, `NFR-002`, `NFR-006`.

---

#### Component: Families Module

**Responsibility:** criar familias, convidar membros, definir idioma e manter o ciclo de vida dos participantes.

**Interfaces Provided:**
- `POST /api/v1/families`
- `GET /api/v1/families/current`
- `POST /api/v1/families/{id}/members`
- `PATCH /api/v1/family-members/{id}`

**Interfaces Required:**
- Identity Module para usuario autenticado;
- Messaging Module para vinculo de numero autorizado;
- Shared Module para auditoria.

**Data Owned:**
- `families`
- `family_members`
- `member_contacts`
- `member_permissions`

**Key Operations:**
1. criar familia e membro administrador inicial;
2. convidar membro por contato;
3. ativar, suspender ou remover membro logicamente;
4. manter idioma e perfil de acesso.

**NFRs Addressed:**
- `NFR-002`, `NFR-006`, `NFR-007`.

---

#### Component: Banking Module

**Responsibility:** cadastrar bancos e contas bancarias e expor referencia financeira estavel para o modulo de lancamentos.

**Interfaces Provided:**
- `GET /api/v1/banks`
- `POST /api/v1/banks`
- `GET /api/v1/accounts`
- `POST /api/v1/accounts`
- `PATCH /api/v1/accounts/{id}`

**Interfaces Required:**
- Families Module para escopo por familia;
- Ledger Module para integridade de saldo e historico.

**Data Owned:**
- `banks`
- `bank_accounts`
- `account_opening_balances`

**Key Operations:**
1. cadastrar banco;
2. cadastrar conta com saldo inicial;
3. inativar banco ou conta sem apagar historico.

**NFRs Addressed:**
- `NFR-006`, `NFR-007`, `NFR-009`.

---

#### Component: Ledger Module

**Responsibility:** registrar receitas, despesas e ajustes, manter saldo por conta e trilha de auditoria.

**Interfaces Provided:**
- `POST /api/v1/transactions`
- `GET /api/v1/transactions`
- `GET /api/v1/balances`
- `POST /api/v1/transactions/{id}/cancel`

**Interfaces Required:**
- Banking Module para conta valida;
- Identity/Families para actor e permissao;
- Messaging Module e AI Module para origem conversacional.

**Data Owned:**
- `transactions`
- `transaction_entries`
- `balance_snapshots` ou visoes derivadas
- `audit_logs`

**Key Operations:**
1. validar e persistir lancamentos;
2. recalcular ou consolidar saldo por conta;
3. cancelar lancamentos preservando historico;
4. retornar saldo consolidado por familia.

**NFRs Addressed:**
- `NFR-003`, `NFR-005`, `NFR-006`.

---

#### Component: Messaging Module

**Responsibility:** receber eventos do WAHA, resolver remetente, manter contexto da conversa e enviar respostas.

**Interfaces Provided:**
- `POST /api/v1/webhooks/waha`
- `POST /api/v1/messages/send` interno ou administrativo
- serviços internos para iniciar, continuar ou cancelar fluxos

**Interfaces Required:**
- WAHA API/webhook;
- Families Module para numero autorizado;
- Ledger Module para consulta e registro;
- AI Module para inferencia de texto ou imagem.

**Data Owned:**
- `message_channels`
- `conversation_sessions`
- `message_events`
- `message_outbox`

**Key Operations:**
1. validar webhook e persistir evento bruto;
2. manter maquina de estados da conversa;
3. responder consultas e confirmacoes;
4. controlar idempotencia e retries.

**NFRs Addressed:**
- `NFR-004`, `NFR-005`, `NFR-010`.

---

#### Component: AI Module

**Responsibility:** encapsular integracoes de inferencia de texto e imagem sem permitir gravacao automatica sem confirmacao.

**Interfaces Provided:**
- `AnalyzeTransactionIntent`
- `AnalyzeReceiptImage`
- `BuildSuggestionSummary`

**Interfaces Required:**
- storage de midia;
- provider de IA externo;
- Messaging Module para retorno ao usuario.

**Data Owned:**
- `ai_analysis_requests`
- `ai_analysis_results`
- referencias de midia processada

**Key Operations:**
1. extrair valor, data, descricao e tipo de movimentacao;
2. retornar confianca e campos sugeridos;
3. falhar de forma segura com fallback manual.

**NFRs Addressed:**
- `NFR-005`, `NFR-006`, `NFR-010`.

---

#### Component: Shared / Platform Module

**Responsibility:** prover capacidades transversais de cache, filas, logs estruturados, correlacao, health checks e configuracao.

**Interfaces Provided:**
- logging e correlation IDs;
- abstrações de fila e dispatch de jobs;
- health endpoints;
- helpers de configuracao e tenant context.

**Interfaces Required:**
- Redis;
- observabilidade da infraestrutura;
- configuracoes de ambiente.

**Data Owned:**
- nenhum dominio de negocio primario;
- tabelas auxiliares de jobs, failed jobs e locks quando aplicavel.

**Key Operations:**
1. expor infraestrutura comum aos modulos;
2. padronizar eventos e logs;
3. suportar monitoramento e retries.

**NFRs Addressed:**
- `NFR-005`, `NFR-007`, `NFR-009`, `NFR-010`.

---

## 4. Data Model

### Entity Relationship Diagram

```text
User ──< FamilyMembership >── Family ──< BankAccount >── Bank
  │               │                    │
  │               └── MemberContact    └──< Transaction >── CreatedBy(User)
  │
  └──────────────────────────────< ConversationSession >──< MessageEvent
                                                   │
                                                   └──< AIAnalysisResult
```

### Entity Specifications

#### Entity: User

**Purpose:** representar a identidade autenticavel do sistema.

**Attributes:**
- `id` (UUID, PK)
- `name` (string)
- `email` (string, unique)
- `password_hash` (string)
- `status` (enum: active, inactive)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- um usuario possui varios memberships;
- um usuario pode criar varios lancamentos.

**Indexes:**
- PK em `id`
- indice unico em `email`

**Constraints:**
- email obrigatorio e unico;
- senha armazenada apenas como hash.

---

#### Entity: Family

**Purpose:** representar o agregado principal de isolamento de dados.

**Attributes:**
- `id` (UUID, PK)
- `name` (string)
- `status` (enum: active, archived)
- `base_currency` (char(3), default `BRL`)
- `created_by_user_id` (UUID, FK)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- uma familia possui membros, bancos, contas, conversas e lancamentos.

**Indexes:**
- PK em `id`
- indice em `created_by_user_id`

**Constraints:**
- nome obrigatorio;
- dados financeiros sempre escopados por familia.

---

#### Entity: FamilyMembership

**Purpose:** vincular usuario ou membro operacional ao contexto da familia.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `user_id` (UUID, FK nullable para convite pendente)
- `role` (enum: owner, admin, member, viewer)
- `language` (string)
- `status` (enum: pending, active, suspended, removed)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- pertence a `Family`;
- referencia `User` quando o convite foi aceito.

**Indexes:**
- indice composto em `(family_id, status)`
- indice em `user_id`

**Constraints:**
- um mesmo usuario nao pode ter memberships duplicados ativos na mesma familia.

---

#### Entity: MemberContact

**Purpose:** armazenar canais de contato autorizados, principalmente telefone WhatsApp.

**Attributes:**
- `id` (UUID, PK)
- `family_membership_id` (UUID, FK)
- `type` (enum: whatsapp, email)
- `value` (string)
- `is_primary` (boolean)
- `verified_at` (timestamp nullable)
- `created_at` (timestamp)

**Relationships:**
- pertence a `FamilyMembership`.

**Indexes:**
- indice composto em `(type, value)`

**Constraints:**
- valor de WhatsApp deve ser normalizado em formato E.164.

---

#### Entity: Bank

**Purpose:** representar instituicao financeira cadastrada.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `name` (string)
- `code` (string nullable)
- `status` (enum: active, inactive)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- uma instituicao pode possuir varias contas.

**Indexes:**
- indice em `(family_id, status)`

**Constraints:**
- nao excluir fisicamente quando houver contas vinculadas.

---

#### Entity: BankAccount

**Purpose:** representar conta financeira que recebe lancamentos.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `bank_id` (UUID, FK)
- `name` (string)
- `account_type` (enum: checking, savings, cash, wallet, other)
- `initial_balance` (decimal(14,2))
- `current_balance` (decimal(14,2))
- `status` (enum: active, inactive)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- pertence a `Family` e `Bank`;
- possui varios `Transaction`.

**Indexes:**
- indice em `(family_id, status)`
- indice em `bank_id`

**Constraints:**
- `current_balance` deve refletir saldo inicial + transacoes validas.

---

#### Entity: Transaction

**Purpose:** representar receita, despesa ou ajuste financeiro.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `bank_account_id` (UUID, FK)
- `created_by_user_id` (UUID nullable, FK)
- `source_channel` (enum: web, whatsapp, ai_assisted, system)
- `type` (enum: income, expense, adjustment)
- `amount` (decimal(14,2))
- `effective_date` (date)
- `description` (string)
- `status` (enum: confirmed, cancelled)
- `origin_message_event_id` (UUID nullable, FK)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- pertence a `Family` e `BankAccount`;
- pode referenciar evento de mensagem;
- possui itens de auditoria.

**Indexes:**
- indice em `(family_id, effective_date)`
- indice em `(bank_account_id, status)`
- indice em `origin_message_event_id`

**Constraints:**
- `amount` sempre positivo; o sinal e inferido por `type`;
- transacao cancelada nao e removida fisicamente.

---

#### Entity: ConversationSession

**Purpose:** manter estado de interacao conversacional com um membro.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `family_membership_id` (UUID, FK)
- `channel` (enum: whatsapp)
- `state` (string)
- `context_payload` (json)
- `last_message_at` (timestamp)
- `expires_at` (timestamp nullable)
- `created_at` (timestamp)
- `updated_at` (timestamp)

**Relationships:**
- pertence a familia e membro;
- possui varios `MessageEvent`.

**Indexes:**
- indice composto em `(family_membership_id, channel, expires_at)`

**Constraints:**
- apenas uma sessao ativa relevante por membro e canal.

---

#### Entity: MessageEvent

**Purpose:** registrar entrada e saida de mensagens trocadas com WAHA.

**Attributes:**
- `id` (UUID, PK)
- `family_id` (UUID, FK)
- `conversation_session_id` (UUID nullable, FK)
- `external_message_id` (string)
- `direction` (enum: inbound, outbound)
- `sender_contact` (string)
- `payload` (json)
- `processing_status` (enum: received, processed, failed, ignored)
- `received_at` (timestamp)
- `processed_at` (timestamp nullable)

**Relationships:**
- pode originar transacoes e analises de IA.

**Indexes:**
- indice unico em `external_message_id`
- indice em `(family_id, processing_status)`

**Constraints:**
- idempotencia baseada em `external_message_id`.

---

#### Entity: AIAnalysisResult

**Purpose:** armazenar sugestoes e confianca de inferencias automatizadas.

**Attributes:**
- `id` (UUID, PK)
- `message_event_id` (UUID, FK)
- `provider` (string)
- `confidence_score` (decimal(5,2))
- `suggested_type` (enum nullable)
- `suggested_amount` (decimal(14,2) nullable)
- `suggested_date` (date nullable)
- `suggested_description` (string nullable)
- `raw_result` (json)
- `created_at` (timestamp)

**Relationships:**
- pertence a um `MessageEvent`.

**Indexes:**
- indice em `message_event_id`

**Constraints:**
- nao cria transacao automaticamente.

---

### Data Storage Strategy

**Primary Database:** MySQL para o backend Laravel, consistente com o ambiente descrito no projeto e adequado ao monolito modular.

**Caching Strategy:** Redis para cache de leituras frequentes, controle de locks, rate limit e fila de jobs.

**File Storage:** armazenamento local em desenvolvimento e backend abstrato para S3 compativel em ambientes futuros, principalmente para imagens e comprovantes.

**Data Retention:** eventos de mensagem e auditoria devem ter retencao ampliada; midias podem ter politica separada apos definicao legal e operacional.

**Backup Strategy:** snapshot diario do banco em ambientes persistentes, com retenção minima inicial de 7 a 14 dias, e backup dos artefatos de storage relevantes.

---

## 5. API Specifications

### API Design Approach

**Protocol:** REST JSON  
**Authentication:** JWT bearer token para frontend; assinatura/segredo para webhook WAHA  
**Versioning:** prefixo `/api/v1` com evolucao backward-compatible sempre que possivel

### Endpoint Groups

#### Auth and Identity

##### `POST /api/v1/auth/login`

**Purpose:** autenticar usuario e emitir tokens.

**Authentication:** None

**Request:**
```json
{
  "email": "admin@familia.local",
  "password": "secret"
}
```

**Response (200 OK):**
```json
{
  "data": {
    "access_token": "jwt",
    "refresh_token": "opaque-or-jwt",
    "token_type": "Bearer",
    "expires_in": 3600,
    "user": {
      "id": "uuid",
      "name": "Administrador",
      "family_contexts": [
        {
          "family_id": "uuid",
          "role": "owner"
        }
      ]
    }
  }
}
```

**Error Responses:**
- `400 Bad Request` - payload invalido
- `401 Unauthorized` - credenciais invalidas
- `429 Too Many Requests` - limite de tentativas de login

**NFRs:**
- Response time target: p95 < 500ms
- Rate limit: 10 tentativas por minuto por IP/identidade

---

##### `POST /api/v1/auth/refresh`

**Purpose:** renovar token sem exigir novo login.

**Authentication:** Refresh token valido

**Response (200 OK):**
```json
{
  "data": {
    "access_token": "jwt",
    "expires_in": 3600
  }
}
```

---

#### Families and Members

##### `POST /api/v1/families`

**Purpose:** criar familia no onboarding.

**Authentication:** Required

**Request:**
```json
{
  "name": "Familia Coelho",
  "base_currency": "BRL"
}
```

**Response (201 Created):**
```json
{
  "data": {
    "id": "uuid",
    "name": "Familia Coelho",
    "membership_role": "owner"
  }
}
```

**Error Responses:**
- `401 Unauthorized` - sem token
- `422 Unprocessable Entity` - validacao falhou

---

##### `POST /api/v1/families/{familyId}/members`

**Purpose:** convidar ou cadastrar membro.

**Authentication:** Required

**Request:**
```json
{
  "name": "Maria",
  "email": "maria@local.test",
  "whatsapp": "+5585999999999",
  "role": "member",
  "language": "pt-BR"
}
```

**Response (201 Created):**
```json
{
  "data": {
    "membership_id": "uuid",
    "status": "pending"
  }
}
```

---

#### Banking and Ledger

##### `POST /api/v1/accounts`

**Purpose:** cadastrar conta bancaria.

**Authentication:** Required

**Request:**
```json
{
  "family_id": "uuid",
  "bank_id": "uuid",
  "name": "Conta Principal",
  "account_type": "checking",
  "initial_balance": 1200.00
}
```

**Response (201 Created):**
```json
{
  "data": {
    "id": "uuid",
    "name": "Conta Principal",
    "current_balance": 1200.00
  }
}
```

---

##### `POST /api/v1/transactions`

**Purpose:** registrar receita, despesa ou ajuste.

**Authentication:** Required

**Request:**
```json
{
  "family_id": "uuid",
  "bank_account_id": "uuid",
  "type": "expense",
  "amount": 59.9,
  "effective_date": "2026-04-17",
  "description": "Mercado"
}
```

**Response (201 Created):**
```json
{
  "data": {
    "id": "uuid",
    "status": "confirmed",
    "updated_balance": 1140.10
  }
}
```

**Error Responses:**
- `401 Unauthorized` - sem token
- `403 Forbidden` - familia fora do escopo do membro
- `422 Unprocessable Entity` - conta ou payload invalido

**NFRs:**
- Response time target: p95 < 500ms
- Consistency target: saldo confirmado no mesmo commit da transacao

---

##### `GET /api/v1/balances?family_id={id}`

**Purpose:** consultar saldo consolidado e por conta.

**Authentication:** Required

**Response (200 OK):**
```json
{
  "data": {
    "family_id": "uuid",
    "total_balance": 3450.22,
    "accounts": [
      {
        "account_id": "uuid",
        "name": "Conta Principal",
        "balance": 1140.10
      }
    ],
    "generated_at": "2026-04-17T11:30:00Z"
  }
}
```

---

#### Messaging and WAHA

##### `POST /api/v1/webhooks/waha`

**Purpose:** receber eventos do WAHA e encaminhar processamento.

**Authentication:** Assinatura ou segredo compartilhado

**Request:** payload conforme contrato do WAHA, persistido como evento bruto.

**Response (202 Accepted):**
```json
{
  "status": "accepted"
}
```

**Error Responses:**
- `401 Unauthorized` - assinatura invalida
- `409 Conflict` - evento duplicado
- `422 Unprocessable Entity` - payload nao reconhecido

**NFRs:**
- Acknowledge target: < 300ms para entrada valida
- Processamento pesado deve ir para fila

---

##### `POST /api/v1/messages/send`

**Purpose:** enviar mensagem ao WAHA a partir de fluxo interno.

**Authentication:** Required ou uso interno autenticado

**Request:**
```json
{
  "family_id": "uuid",
  "membership_id": "uuid",
  "channel": "whatsapp",
  "message": "Seu saldo atual e R$ 1.140,10"
}
```

**Response (202 Accepted):**
```json
{
  "data": {
    "queued": true
  }
}
```

---

### Internal Interaction Contracts

- `Messaging -> Ledger`: `GetBalanceForMember`, `CreateTransactionFromConversation`
- `Messaging -> AI`: `AnalyzeIncomingMedia`
- `Families -> Messaging`: `ResolveAuthorizedContact`
- `Shared -> All`: correlation ID, tenant context e dispatch de jobs

### API Security

**Authentication:**
- JWT bearer para frontend e APIs administrativas.
- webhook WAHA validado por segredo compartilhado, IP allowlist opcional e idempotencia.

**Authorization:**
- RBAC por membership (`owner`, `admin`, `member`, `viewer`) com policies do Laravel.
- Escopo obrigatório por `family_id` resolvido no contexto autenticado.

**Rate Limiting:**
- login, refresh e webhooks protegidos por throttling.
- endpoints sensiveis com limites por usuario e por IP.

**Input Validation:**
- Form Requests no Laravel;
- DTOs por modulo para casos de uso internos;
- normalizacao de telefone, moeda e datas antes do dominio.

---

## 6. Non-Functional Requirements Mapping

### NFR Coverage Matrix

| NFR ID | Categoria | Requisito | Decisao Arquitetural | Status |
|--------|-----------|-----------|----------------------|--------|
| NFR-001 | Security | JWT e segredos protegidos | JWT com expiracao curta, refresh controlado, segredos via env e middleware de autenticacao | Addressed |
| NFR-002 | Security | Isolamento por familia | Policies, escopo por `family_id`, memberships e filtros obrigatorios em repositorios | Addressed |
| NFR-003 | Performance | CRUD e saldo com baixa latencia | indices, consultas paginadas, cache seletivo e agregados simples por conta | Addressed |
| NFR-004 | Performance | Resposta conversacional rapida | webhook responde 202 rapido e processamento pesado vai para fila | Addressed |
| NFR-005 | Reliability | Idempotencia e reprocessamento | `external_message_id` unico, jobs reenfileiraveis e transacoes cancelaveis | Addressed |
| NFR-006 | Auditability | Trilhas de auditoria | `audit_logs`, `message_events`, actor e canal de origem em todo lancamento | Addressed |
| NFR-007 | Maintainability | Modularidade em `app/Modules` | modular monolith com contratos claros e shared kernel minimo | Addressed |
| NFR-008 | Usability | Poucos passos e erros claros | frontend Vue desacoplado com flows simples e mensagens contextuais | Addressed |
| NFR-009 | Portability | Ambiente local reproduzivel | Docker Compose com backend, frontend, Redis, MySQL e WAHA | Addressed |
| NFR-010 | Observability | Logs e diagnostico | logs estruturados, correlation ID, health checks e metricas por modulo | Addressed |

### Detailed NFR Implementations

#### Performance

**Requirement:** APIs principais com p95 abaixo de 500 ms e consulta de saldo abaixo de 800 ms.

**Architectural Decisions:**
1. indices em `family_id`, `status`, `effective_date`, `external_message_id`;
2. paginacao obrigatoria em listagens administrativas;
3. cache Redis para saldos recentemente consultados, referenciais e locks curtos;
4. webhook WAHA com resposta rapida e delegacao do processamento para fila;
5. uso de queries agregadas simples, evitando joins excessivos nas consultas mais frequentes.

#### Scalability

**Requirement:** crescimento controlado sem reescrever a base tecnica do MVP.

**Architectural Decisions:**
1. backend stateless com JWT;
2. horizontal scaling possivel do container Laravel API e dos workers;
3. Redis para desacoplar picos de mensagens;
4. possibilidade futura de read replicas caso a carga de leitura aumente.

#### Security

**Requirement:** proteger autenticacao, escopo familiar, webhook e dados sensiveis.

**Architectural Decisions:**
1. JWT com expiracao curta e refresh controlado;
2. TLS obrigatório fora do ambiente local;
3. validacao de entrada com Form Requests e DTOs;
4. segredos via `.env` e futuramente secret manager;
5. auditoria de eventos sensiveis e trilha de actor.

#### Reliability

**Requirement:** evitar duplicidade de eventos e preservar consistencia dos saldos.

**Architectural Decisions:**
1. `external_message_id` como chave de idempotencia;
2. processamento com retries exponenciais em jobs falhos;
3. gravacao de transacao e atualizacao de saldo na mesma transacao de banco;
4. cancelamento logico em vez de exclusao.

#### Availability

**Requirement:** disponibilidade operacional suficiente para uso familiar com recuperacao simples.

**Architectural Decisions:**
1. health checks para API, worker, Redis, MySQL e WAHA;
2. reinicio de containers por politica do orchestrator;
3. backup diario do banco em ambientes persistentes;
4. RTO inicial de ate 4 horas e RPO inicial de ate 24 horas para ambiente nao critico.

#### Maintainability

**Requirement:** evolucao segura por modulos e onboarding simples da equipe.

**Architectural Decisions:**
1. separacao em `Domain`, `Application`, `Infrastructure` e `Interfaces`;
2. testes unitarios por modulo e integracao para fluxos intermodulo;
3. contratos REST documentados;
4. padroes compartilhados apenas em `Shared`.

#### Observability

**Requirement:** diagnosticar falhas em autenticacao, webhook e filas.

**Architectural Decisions:**
1. logs estruturados com `correlation_id`, `family_id`, `module`;
2. metrica de tempo de resposta do webhook e tempo de processamento da fila;
3. rastreamento de `message_event_id` ate `transaction_id`;
4. health endpoint e painel simples de failed jobs.

---

## 7. Technology Stack

| Camada | Tecnologia | Status | Rationale |
|--------|------------|--------|-----------|
| Backend API | Laravel 13 + PHP 8.3 | Confirmada no workspace | Alinha com `laravel/composer.json` e suporta monolito modular com alta produtividade |
| Frontend | Vue 3 SPA | Decisao arquitetural | Atende requisito de frontend desacoplado e consumo de REST |
| Build frontend | Vite 8 | Parcialmente presente no workspace Laravel | Tooling atual e simples para SPA |
| Banco principal | MySQL | Decisao do projeto | Coerente com ambiente atual e CRUD transacional do MVP |
| Cache/Fila | Redis | Decisao arquitetural | Necessario para jobs, locks e caches de baixa latencia |
| WhatsApp transport | WAHA | Confirmado no workspace | Camada especializada para webhooks e envio de mensagens |
| Processamento assíncrono | Laravel Queue workers | Decisao arquitetural | Mantem complexidade baixa e integra bem com Redis |
| Armazenamento de arquivos | Local/S3-compatible abstraction | Decisao arquitetural | Permite desenvolvimento local e evolucao futura |
| Observabilidade | logs estruturados + health checks | Decisao arquitetural | Suficiente para MVP e troubleshooting |
| Containerizacao | Docker Compose | Requisito arquitetural | Portabilidade e reproduzibilidade do ambiente |

### Directory and Repository Strategy

- `laravel/`: backend principal do produto.
- `laravel/app/Modules/`: modulos de dominio.
- `laravel/routes/`: bootstrap leve apontando para modulos.
- `frontend/` ou repositorio Vue separado: SPA oficial do produto.
- `waha/`: dependencia operacional versionada localmente para o canal WhatsApp.
- `docs/bmad/`: artefatos BMAD.

### Testing Strategy

- unit tests por modulo de dominio;
- integration tests para controllers, policies e persistencia;
- contract tests para payloads WAHA;
- e2e tests prioritarios para onboarding, saldo e fluxo conversacional critico.

---

## 8. Trade-off Analysis

### Decision 1: Modular Monolith vs Microservices

**Chosen:** Modular Monolith

**Benefits:**
- menor custo operacional;
- consistencia transacional simples;
- produtividade alta para equipe pequena;
- evolucao gradual para extração futura de componentes.

**Costs / Trade-offs:**
- escalabilidade ainda ocorre em unidade maior;
- exige disciplina forte para manter fronteiras modulares;
- banco compartilhado pode induzir acoplamento se mal governado.

### Decision 2: REST + Webhooks vs Event Bus completo

**Chosen:** REST para frontend e webhook + jobs para WhatsApp

**Benefits:**
- modelo simples de implementar e depurar;
- alinhado com requisitos atuais;
- reduz dependencias de infraestrutura.

**Costs / Trade-offs:**
- menor flexibilidade para multiplos consumidores assíncronos;
- eventos internos exigem convencoes claras mesmo sem event bus dedicado.

### Decision 3: MySQL + saldos materializados vs Event Sourcing

**Chosen:** modelo relacional transacional com historico auditavel

**Benefits:**
- mais simples para MVP;
- consultas diretas e manutencao facilitada;
- menor curva operacional.

**Costs / Trade-offs:**
- menor capacidade de replay total do dominio;
- reconciliacao historica profunda exigira desenho adicional no futuro.

### Decision 4: WAHA externo vs logica WhatsApp embutida

**Chosen:** WAHA como camada especializada de transporte

**Benefits:**
- desacopla o produto da complexidade do protocolo WhatsApp;
- reduz manutencao de conectividade e sessao;
- mantém Laravel focado em regra de negocio.

**Costs / Trade-offs:**
- dependencia operacional externa;
- exige observabilidade e retentativa para falhas de integracao.

---

## 9. Deployment Architecture

### Local Development Topology

```text
docker compose
  ├── app-api        -> Laravel API
  ├── app-worker     -> Laravel queue worker
  ├── app-scheduler  -> Laravel scheduler opcional
  ├── frontend       -> Vue SPA
  ├── redis          -> cache + queue
  ├── mysql          -> banco principal
  └── waha           -> gateway WhatsApp
```

### Network and Integration Flow

1. frontend Vue chama `app-api` por HTTP interno/externo;
2. WAHA envia webhook para `app-api`;
3. `app-api` persiste evento e enfileira processamento;
4. `app-worker` consulta Redis e MySQL, resolve fluxo e solicita envio via WAHA;
5. WAHA entrega a mensagem ao WhatsApp.

### Environment Variables

Variaveis criticas esperadas:

- `APP_ENV`, `APP_KEY`, `APP_URL`
- `DB_CONNECTION`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- `REDIS_HOST`, `REDIS_PORT`
- `JWT_SECRET` ou equivalente da biblioteca adotada
- `WAHA_BASE_URL`, `WAHA_API_KEY`, `WAHA_WEBHOOK_SECRET`
- `FILESYSTEM_DISK`
- `AI_PROVIDER`, `AI_API_KEY`

### Deployment Notes

- Em desenvolvimento, MySQL pode rodar em container para padronizar bootstrap, mesmo que o product brief tenha citado MySQL do host.
- Em homologacao/producao inicial, API e workers podem escalar separadamente.
- WAHA deve possuir volume persistente para sessao, quando requerido pela configuracao escolhida.

### CI/CD and Operational Flow

- lint e testes unitarios no backend Laravel;
- testes de build no frontend Vue;
- validacao de contratos WAHA em pipeline;
- build de imagens Docker versionadas por commit;
- rollout inicial manual ou semiautomatico.

---

## 10. Future Considerations

### Planned Evolution Paths

1. extrair `Messaging` para servico separado se o volume de mensagens crescer mais rapido que o core financeiro;
2. introduzir storage S3 compatível para comprovantes e anexos;
3. adicionar read models especificos para relatorios;
4. considerar event sourcing apenas se auditoria temporal integral se tornar necessidade central;
5. adicionar suporte a multiplas familias por usuario com troca de contexto mais sofisticada.

### Risks Requiring Follow-up

- definicao exata da biblioteca JWT no Laravel ainda precisa ser fechada na implementacao;
- fluxo de estados da conversa precisa de especificacao tecnica detalhada antes das primeiras historias;
- estrategia de refresh token e revogacao precisa ser decidida no sprint tecnico;
- politica de retencao de midias e dados pessoais deve ser detalhada antes de uso intensivo.

### Architecture Readiness Summary

Esta arquitetura e suficiente para seguir para `bmad:sprint-plan`, mas o caminho BMAD natural continua sendo executar `bmad:gate-check` se o time quiser uma avaliacao formal de cobertura antes de quebrar historias.

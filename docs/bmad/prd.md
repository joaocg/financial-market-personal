# Product Requirements Document (PRD)

- **Nome do Projeto:** Financeiro Familiar com WhatsApp
- **Versao do Documento:** 0.1
- **Data:** 2026-04-17
- **Autor:** Codex + Joao Coelho
- **Status:** Draft

---

## Controle do Documento

| Versao | Data | Autor | Alteracoes |
|---------|------|-------|------------|
| 0.1 | 2026-04-17 | Codex + Joao Coelho | Primeira versao do PRD baseada no product brief |

## Aprovacoes

| Papel | Nome | Assinatura | Data |
|------|------|-----------|------|
| Product Owner | | | |
| Engineering Lead | | | |
| Design Lead | | | |
| Stakeholder | | | |

---

## Executive Summary

**Problema:**  
Familias controlam entradas, despesas e saldos em canais desconectados, com baixa disciplina de registro, pouca visibilidade compartilhada e alto retrabalho de conciliacao.

**Solucao Proposta:**  
Construir um sistema financeiro familiar com backend Laravel modular, frontend Vue desacoplado e operacao transacional por WhatsApp via WAHA, permitindo cadastrar estrutura financeira, consultar saldos e registrar movimentacoes por interface web ou conversa.

**Valor de Negocio:**  
O produto reduz atrito no registro financeiro, aumenta a adesao ao processo e centraliza a governanca financeira da familia em uma unica plataforma operacional.

**Metricas de Sucesso:**
- Pelo menos 80% dos lancamentos do MVP registrados em ate 24 horas apos o evento.
- Pelo menos 60% dos membros ativos utilizando o canal WhatsApp ao menos 1 vez por semana.
- Divergencia de saldo manual inferior a 2% nas contas ativas apos 30 dias de uso.

**Janela de Lancamento:** MVP interno apos conclusao da fase inicial de arquitetura e sprint planning.

---

## Sumario

1. [Project Overview](#project-overview)
2. [Objetivos e Metas](#objetivos-e-metas)
3. [Personas e Usuarios](#personas-e-usuarios)
4. [Modulos do Sistema](#modulos-do-sistema)
5. [Functional Requirements](#functional-requirements)
6. [Non-Functional Requirements](#non-functional-requirements)
7. [Fluxos do Usuario](#fluxos-do-usuario)
8. [Regras de Negocio](#regras-de-negocio)
9. [Integracoes Externas](#integracoes-externas)
10. [Epicos e Historias Candidatas](#epicos-e-historias-candidatas)
11. [Assumptions and Dependencies](#assumptions-and-dependencies)
12. [Out of Scope](#out-of-scope)
13. [Planejamento de Releases](#planejamento-de-releases)
14. [Riscos e Mitigacoes](#riscos-e-mitigacoes)
15. [Rastreabilidade](#rastreabilidade)
16. [Handoff para Arquitetura](#handoff-para-arquitetura)

---

## Project Overview

### Contexto

O sistema `Financeiro` atende a necessidade de controle financeiro familiar colaborativo, com foco em baixa friccao operacional. O comportamento natural do usuario ocorre em grande parte no WhatsApp, enquanto atividades administrativas e de configuracao exigem uma interface web estruturada.

### Estado Atual

O controle financeiro familiar costuma ocorrer em planilhas, cadernos, apps isolados e mensagens dispersas. Isso gera:

- ausencia de fonte unica da verdade;
- atraso no registro de eventos financeiros;
- pouca rastreabilidade de quem registrou cada movimentacao;
- baixa consistencia na classificacao e conciliacao de dados.

### Estado Desejado

Ao final do MVP, a familia deve conseguir:

- criar sua estrutura financeira;
- cadastrar membros, bancos e contas;
- registrar credito e despesa via web ou WhatsApp;
- consultar saldo consolidado e por conta;
- manter historico auditavel de interacoes e lancamentos.

### Stakeholders

| Stakeholder | Papel | Interesse | Influencia |
|-------------|------|-----------|-----------|
| Responsavel financeiro da familia | Product Owner de negocio | Confiabilidade e visibilidade financeira | Alta |
| Membros operacionais | Usuarios finais | Rapidez e simplicidade para registrar movimentacoes | Alta |
| Engineering Lead | Responsavel tecnico | Arquitetura modular, seguranca e integracao | Alta |
| Futuro contador ou consultor | Stakeholder consultivo | Exportacao e consistencia dos dados | Media |

---

## Objetivos e Metas

### Objetivos de Negocio

1. Centralizar o controle financeiro familiar em um sistema unico.
2. Reduzir o atrito de registro com operacao conversacional no WhatsApp.
3. Fornecer uma base modular que suporte evolucao para automacoes, IA e relatorios.

### Objetivos do Usuario

1. Registrar uma despesa ou receita em menos de 1 minuto.
2. Consultar saldo total e por conta sem abrir planilhas.
3. Compartilhar a operacao financeira com outros membros de forma controlada.

### Criterios de Sucesso

- Fluxo inicial de onboarding concluido por uma familia sem suporte tecnico manual.
- Registro de movimentacao via WhatsApp funcionando com confirmacao explicita.
- Backend e frontend desacoplados operando com autenticacao JWT e contratos de API claros.

---

## Personas e Usuarios

### Persona Primaria: Administrador da Familia

**Perfil:**
- adulto responsavel pela organizacao financeira da familia;
- familiarizado com web e configuracoes basicas;
- usa o WhatsApp diariamente.

**Objetivos:**
- configurar familias, membros, bancos e contas;
- acompanhar saldo consolidado e historico;
- controlar permissoes de acesso e uso do canal conversacional.

**Dores:**
- consolidacao manual de informacoes;
- cobranca recorrente para obter comprovantes e lancamentos;
- falta de trilha de auditoria por membro.

### Persona Secundaria: Membro Operacional

**Perfil:**
- adulto ou dependente com permissao restrita;
- menor tolerancia a formulários longos;
- prefere interacao rapida por conversa.

**Objetivos:**
- registrar despesa ou recebimento com poucos passos;
- consultar saldo da conta relevante;
- enviar texto ou comprovante e receber confirmacao.

**Dores:**
- esquecer de registrar transacoes;
- dificuldade com sistemas administrativos extensos;
- receio de cometer erros de classificacao.

---

## Modulos do Sistema

### Modulo 1: Identidade e Acesso

Responsavel por autenticacao JWT, sessao, perfil do usuario, vinculo com familia e autorizacao por papeis.

### Modulo 2: Familias e Membros

Responsavel por criacao de familia, convite de membros, configuracao de idioma, papeis e estado de participacao.

### Modulo 3: Instituicoes Financeiras

Responsavel por cadastro de bancos e padroes de identificacao visiveis para o usuario.

### Modulo 4: Contas Bancarias

Responsavel por contas da familia, saldo inicial, status da conta e referencia ao banco.

### Modulo 5: Lancamentos Financeiros

Responsavel por receitas, despesas, ajustes manuais, historico de saldo e trilha de auditoria.

### Modulo 6: Conversas WhatsApp

Responsavel por receber eventos do WAHA, validar membro, manter contexto da conversa, enviar mensagens e disparar fluxos guiados.

### Modulo 7: Assistencia Inteligente

Responsavel por interpretar mensagem, imagem ou comprovante e sugerir classificacao e campos para confirmacao humana.

### Modulo 8: Painel Web

Responsavel pela experiencia Vue para onboarding, consulta, gestao e operacao assistida.

### Modulo 9: Observabilidade e Operacao

Responsavel por logs, filas, auditoria, metricas operacionais e configuracao via Docker.

---

## Functional Requirements

### FR-001: Criacao de familia [MUST]

**Descricao:**  
O sistema deve permitir a criacao de uma familia com um administrador inicial.

**Acceptance Criteria:**
- Permitir cadastro de nome da familia e dados basicos do administrador.
- Criar automaticamente o vinculo do usuario criador como administrador.
- Bloquear criacao de familia duplicada para o mesmo contexto quando a regra de unicidade estiver ativa.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-01 Onboarding e identidade

### FR-002: Convite e gestao de membros [MUST]

**Descricao:**  
O sistema deve permitir convidar membros por canal definido, atribuir papel e configurar idioma individual.

**Acceptance Criteria:**
- Permitir cadastrar convite com nome, contato e papel.
- Permitir idioma preferencial por membro.
- Permitir ativar, suspender ou remover participacao do membro sem apagar historico de auditoria.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-01 Onboarding e identidade

### FR-003: Autenticacao JWT para frontend e APIs [MUST]

**Descricao:**  
O backend deve emitir e validar tokens JWT para autenticar usuarios do frontend Vue e chamadas internas protegidas.

**Acceptance Criteria:**
- Permitir login com credenciais validas e emissao de access token.
- Permitir refresh ou renovacao conforme estrategia definida na arquitetura.
- Rejeitar chamadas protegidas com token ausente, invalido ou expirado.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-01 Onboarding e identidade

### FR-004: Cadastro de bancos [MUST]

**Descricao:**  
O sistema deve permitir cadastrar bancos ou instituicoes financeiras usados pela familia.

**Acceptance Criteria:**
- Permitir nome, codigo e status ativo ou inativo.
- Impedir exclusao se houver contas vinculadas, substituindo por inativacao.
- Permitir consulta paginada e filtragem no frontend.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-02 Estrutura financeira

### FR-005: Cadastro de contas bancarias [MUST]

**Descricao:**  
O sistema deve permitir cadastrar contas bancarias por familia, associadas a um banco e a um saldo inicial.

**Acceptance Criteria:**
- Exigir familia, banco, nome da conta e saldo inicial.
- Permitir conta com saldo inicial zero.
- Manter historico do saldo inicial para rastreabilidade.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-02 Estrutura financeira

### FR-006: Registro manual de despesa [MUST]

**Descricao:**  
O sistema deve permitir registrar uma despesa vinculada a uma conta bancaria.

**Acceptance Criteria:**
- Exigir valor, conta, data efetiva e descricao minima.
- Reduzir o saldo da conta apos confirmacao do lancamento.
- Registrar usuario responsavel, canal de origem e timestamps.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-03 Motor financeiro

### FR-007: Registro manual de receita ou credito [MUST]

**Descricao:**  
O sistema deve permitir registrar entradas financeiras vinculadas a uma conta bancaria.

**Acceptance Criteria:**
- Exigir valor, conta, data efetiva e descricao minima.
- Aumentar o saldo da conta apos confirmacao.
- Permitir origem via web ou WhatsApp.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-03 Motor financeiro

### FR-008: Consulta de saldo consolidado [MUST]

**Descricao:**  
O sistema deve apresentar saldo total da familia e saldo por conta.

**Acceptance Criteria:**
- Disponibilizar consulta no frontend Vue.
- Disponibilizar consulta por comando ou intencao no WhatsApp.
- Informar data e hora da ultima atualizacao considerada.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-03 Motor financeiro

### FR-009: Recepcao de webhooks WAHA [MUST]

**Descricao:**  
O backend deve receber eventos do WAHA e convertê-los em comandos internos de conversa.

**Acceptance Criteria:**
- Validar origem do webhook conforme segredo ou mecanismo configurado.
- Persistir evento bruto para auditoria e reprocessamento quando aplicavel.
- Ignorar ou marcar como nao autorizado mensagens de remetentes sem vinculo ativo.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-04 Conversas WhatsApp

### FR-010: Fluxo guiado de lancamento via WhatsApp [MUST]

**Descricao:**  
O sistema deve conduzir o usuario em um fluxo conversacional para registrar despesa ou receita.

**Acceptance Criteria:**
- Perguntar intencao quando a mensagem inicial nao for suficiente.
- Solicitar e confirmar dados obrigatorios antes de persistir.
- Permitir cancelamento explicito do fluxo em andamento.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-04 Conversas WhatsApp

### FR-011: Consulta de saldo via WhatsApp [MUST]

**Descricao:**  
O sistema deve responder consultas de saldo geral ou por conta no canal WhatsApp.

**Acceptance Criteria:**
- Identificar membro autenticado pelo numero autorizado.
- Responder no idioma preferencial do membro quando suportado.
- Restringir visao conforme permissoes definidas para o membro.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-04 Conversas WhatsApp

### FR-012: Sugestao assistida por IA a partir de texto e imagem [SHOULD]

**Descricao:**  
O sistema deve interpretar textos livres e comprovantes de imagem para sugerir campos de lancamento.

**Acceptance Criteria:**
- Extrair, quando possivel, tipo de movimentacao, valor, data e descricao.
- Exibir ou responder sugestao com nivel de confianca.
- Exigir confirmacao humana antes de gravar qualquer lancamento inferido.

**Prioridade:** Should Have  
**Epic Relacionado:** EPIC-05 Assistencia inteligente

### FR-013: Historico e auditoria de lancamentos [MUST]

**Descricao:**  
O sistema deve manter trilha auditavel de alteracoes, origem do lancamento e actor responsavel.

**Acceptance Criteria:**
- Registrar criacao, edicao, cancelamento e origem do evento.
- Associar historico ao usuario ou origem sistemica.
- Disponibilizar consulta administrativa do historico no frontend.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-03 Motor financeiro

### FR-014: Frontend Vue desacoplado consumindo API REST [MUST]

**Descricao:**  
O sistema deve oferecer uma interface Vue separada do backend, consumindo contratos REST autenticados por JWT.

**Acceptance Criteria:**
- Permitir login, onboarding e operacoes basicas sem dependencia de renderizacao server-side.
- Centralizar configuracao de base URL, autenticacao e tratamento de erros no frontend.
- Manter compatibilidade de contrato entre frontend e backend por versionamento de API.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-06 Painel web

### FR-015: Backend Laravel modular em `app/Modules` [MUST]

**Descricao:**  
O backend deve organizar dominio, casos de uso e adaptadores em modulos independentes.

**Acceptance Criteria:**
- Cada modulo deve possuir fronteira clara de responsabilidade.
- Rotas, servicos, DTOs, regras e persistencia devem ser organizados por contexto.
- Novos modulos devem ser adicionados sem acoplamento circular entre dominios.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-07 Fundacao tecnica

### FR-016: Execucao local via Docker [MUST]

**Descricao:**  
O sistema deve poder ser executado em ambiente local com Docker Compose, incluindo servicos necessarios para backend, frontend e WAHA.

**Acceptance Criteria:**
- Disponibilizar orquestracao padrao para subir os servicos essenciais.
- Garantir configuracao de rede e variaveis de ambiente documentadas.
- Permitir bootstrap previsivel do ambiente de desenvolvimento.

**Prioridade:** Must Have  
**Epic Relacionado:** EPIC-07 Fundacao tecnica

---

## Non-Functional Requirements

### NFR-001: Seguranca de autenticacao [MUST]

**Descricao:**  
Tokens JWT, credenciais e segredos de integracao devem ser protegidos e validados em todas as chamadas sensiveis.

**Criterios de Aceitacao:**
- Tokens devem possuir expiracao configuravel e assinatura valida.
- Segredos do WAHA e variaveis sensiveis nao devem ser expostos no frontend.

**Metodo de Medicao:** Revisao de seguranca da configuracao e testes de autenticacao negativa.

### NFR-002: Autorizacao por contexto familiar [MUST]

**Descricao:**  
Nenhum usuario deve acessar dados de familia diferente da sua area autorizada.

**Criterios de Aceitacao:**
- Toda consulta autenticada deve aplicar escopo por familia.
- Endpoints e comandos devem retornar erro de autorizacao quando houver tentativa de acesso indevido.

**Compliance:** Politica interna de segregacao logica por tenant familiar.

### NFR-003: Desempenho de API [SHOULD]

**Descricao:**  
Consultas e operacoes comuns do MVP devem responder com baixa latencia em carga inicial esperada.

**Criterios de Aceitacao:**
- Operacoes CRUD principais devem responder em p95 inferior a 500 ms sem contar dependencias externas.
- Consulta de saldo deve responder em p95 inferior a 800 ms.

**Metodo de Medicao:** Testes de carga local e em ambiente homologatorio.

### NFR-004: Desempenho conversacional [SHOULD]

**Descricao:**  
Interacoes simples via WhatsApp devem receber resposta perceptivelmente rapida.

**Criterios de Aceitacao:**
- Consultas de saldo devem responder em ate 5 segundos em 95% dos casos.
- Confirmacoes de recebimento de mensagem devem ocorrer mesmo quando houver processamento assincrono posterior.

**Metodo de Medicao:** Instrumentacao de webhook e tempo total de resposta por mensagem.

### NFR-005: Confiabilidade de processamento [MUST]

**Descricao:**  
Eventos de WhatsApp e jobs de processamento devem suportar reexecucao segura.

**Criterios de Aceitacao:**
- Webhooks devem possuir controle de idempotencia.
- Jobs falhos devem poder ser reenfileirados sem duplicar lancamentos.

**Target SLA:** 99,0% de processamento bem-sucedido para eventos validos do MVP.

### NFR-006: Auditabilidade [MUST]

**Descricao:**  
A plataforma deve registrar eventos essenciais para rastrear origem, alteracoes e decisoes automatizadas.

**Criterios de Aceitacao:**
- Lancamentos devem conter actor, canal, timestamps e referencia de origem.
- Sugestoes de IA devem registrar payload resumido e decisao final do usuario.

**Metodo de Medicao:** Revisao de schema e trilhas de log.

### NFR-007: Modularidade e manutenibilidade [MUST]

**Descricao:**  
O backend deve permitir evolucao por modulos sem dependencias tecnicas acidentais.

**Criterios de Aceitacao:**
- Modulos em `app/Modules` devem ter contratos explicitos.
- Mudancas em um modulo nao devem exigir alteracoes arbitrarias em modulos nao relacionados.

**Metodo de Medicao:** Revisao arquitetural e analise de dependencias.

### NFR-008: Usabilidade do frontend [SHOULD]

**Descricao:**  
As principais operacoes administrativas e operacionais devem exigir poucos passos e linguagem clara.

**Criterios de Aceitacao:**
- Cadastro de conta deve ser concluido em ate 3 etapas logicas.
- Erros de validacao devem ser exibidos de forma contextual e compreensivel.

**Metodo de Medicao:** Testes exploratorios e revisao de UX.

### NFR-009: Portabilidade de ambiente [MUST]

**Descricao:**  
O ambiente de desenvolvimento deve ser reproduzivel com Docker para reduzir variacoes locais.

**Criterios de Aceitacao:**
- Documentacao deve definir comando unico ou conjunto curto de comandos para subir a stack.
- Servicos devem iniciar com healthchecks e dependencias minimas declaradas.

**Load Profile:** Equipe pequena de desenvolvimento com execucao local simultanea dos servicos.

### NFR-010: Observabilidade operacional [SHOULD]

**Descricao:**  
Falhas de integracao, autenticacao e processamento devem ser detectaveis rapidamente.

**Criterios de Aceitacao:**
- Logs estruturados devem identificar modulo, correlacao e tipo de evento.
- Erros de webhook, fila e autenticacao devem possuir metricas e contexto minimo para diagnostico.

**Metodo de Medicao:** Revisao de logs e validacao de traces ou correlacoes.

---

## Fluxos do Usuario

### Flow 1: Onboarding da familia via web

1. Usuario acessa o frontend Vue e cria sua conta.
2. Usuario autentica e cria a familia.
3. Usuario cadastra bancos e contas iniciais.
4. Usuario convida membros e define papeis e idioma.
5. Sistema confirma configuracao inicial e apresenta saldo consolidado inicial.

### Flow 2: Registro de despesa via WhatsApp

1. Membro autorizado envia mensagem indicando uma despesa.
2. Sistema identifica o remetente e o contexto da familia.
3. Sistema confirma os dados obrigatorios ausentes, como valor, conta ou data.
4. Usuario confirma o resumo final.
5. Sistema persiste o lancamento, atualiza saldo e envia comprovante textual da operacao.

### Flow 3: Consulta de saldo via WhatsApp

1. Membro autorizado envia intencao de consultar saldo.
2. Sistema identifica idioma e escopo do membro.
3. Sistema busca saldo consolidado ou por conta.
4. Sistema responde com resumo simples e data da ultima atualizacao.

### Flow 4: Registro assistido com imagem

1. Usuario envia print ou comprovante.
2. Sistema armazena a midia e encaminha para processamento.
3. Modulo de assistencia sugere tipo, valor, data e descricao.
4. Sistema pede confirmacao ao usuario.
5. Apenas apos confirmacao o lancamento e gravado.

### Flow 5: Operacao administrativa via painel web

1. Administrador faz login com JWT.
2. Administra membros, contas e bancos.
3. Consulta historico de lancamentos e eventos.
4. Corrige ou cancela lancamentos conforme permissao.

---

## Regras de Negocio

1. Toda conta bancaria pertence exatamente a uma familia.
2. Todo membro ativo pertence a pelo menos uma familia valida no contexto do MVP.
3. Toda movimentacao precisa estar vinculada a uma conta bancaria.
4. Despesa sempre reduz saldo; receita sempre aumenta saldo.
5. Cancelamento de lancamento deve preservar historico e nao apagar trilha de auditoria.
6. Apenas numeros WhatsApp autorizados podem operar em nome de um membro.
7. O idioma de resposta no WhatsApp deve seguir a preferencia do membro quando houver suporte implementado.
8. Sugestoes de IA nunca podem gerar persistencia automatica sem confirmacao humana no MVP.
9. Bancos e contas com historico associado devem ser inativados, e nao removidos fisicamente, salvo regra futura especifica.
10. Todo acesso a dados financeiros deve ser escopado por familia e permissao.

---

## Integracoes Externas

### WAHA

**Objetivo:** prover camada de transporte para envio e recebimento de mensagens WhatsApp.

**Requisitos de Integracao:**
- Receber webhooks de mensagens e eventos relevantes.
- Permitir envio de respostas textuais e, futuramente, anexos.
- Configurar autenticacao ou segredo de webhook.
- Registrar falhas de comunicacao e permitir reprocessamento.

**Responsabilidade do Sistema:**
- WAHA nao decide regra de negocio.
- Laravel interpreta eventos, mantem contexto de conversa e produz resposta.

### Autenticacao JWT

**Objetivo:** autenticar frontend Vue e endpoints protegidos.

**Requisitos de Integracao:**
- Emissao de token em login.
- Validacao em middleware centralizado.
- Suporte a expiracao, revogacao ou renovacao conforme definicao arquitetural.

### IA para interpretacao de texto e imagem

**Objetivo:** sugerir classificacao e preenchimento de campos para reduzir atrito.

**Requisitos de Integracao:**
- Operar como servico auxiliar desacoplado.
- Retornar payload estruturado com confianca.
- Manter fallback manual quando a inferencia falhar ou estiver incerta.

---

## Epicos e Historias Candidatas

### EPIC-01: Onboarding e identidade

**Objetivo:** permitir que a familia entre no sistema com seguranca e papeis definidos.

**Historias candidatas:**
- Como administrador, quero criar minha familia para iniciar o uso do sistema.
- Como administrador, quero convidar membros para compartilhar a operacao financeira.
- Como usuario, quero fazer login com token seguro para acessar apenas meus recursos.

### EPIC-02: Estrutura financeira

**Objetivo:** modelar bancos e contas da familia.

**Historias candidatas:**
- Como administrador, quero cadastrar bancos usados pela familia.
- Como administrador, quero cadastrar contas com saldo inicial.
- Como administrador, quero inativar contas ou bancos sem perder historico.

### EPIC-03: Motor financeiro

**Objetivo:** registrar e consultar movimentacoes de forma confiavel.

**Historias candidatas:**
- Como membro, quero registrar uma despesa para manter o saldo atualizado.
- Como membro, quero registrar um credito para refletir entradas recebidas.
- Como administrador, quero consultar historico e auditoria de lancamentos.

### EPIC-04: Conversas WhatsApp

**Objetivo:** operar consultas e lancamentos por conversa.

**Historias candidatas:**
- Como membro, quero consultar saldo via WhatsApp para agir rapidamente.
- Como membro, quero registrar uma despesa por mensagem para evitar esquecimento.
- Como sistema, quero identificar fluxos em andamento para conduzir a conversa corretamente.

### EPIC-05: Assistencia inteligente

**Objetivo:** reduzir atrito na entrada de dados usando inferencia.

**Historias candidatas:**
- Como membro, quero enviar um comprovante e receber uma sugestao de lancamento.
- Como sistema, quero informar confianca e pedir confirmacao antes de gravar.

### EPIC-06: Painel web

**Objetivo:** oferecer operacao administrativa e visibilidade estruturada.

**Historias candidatas:**
- Como administrador, quero um painel para ver saldo consolidado e contas.
- Como administrador, quero gerenciar membros e configuracoes da familia.
- Como usuario, quero visualizar mensagens de erro e estados de carregamento de forma clara.

### EPIC-07: Fundacao tecnica

**Objetivo:** garantir modularidade, deploy local e operacao previsivel.

**Historias candidatas:**
- Como desenvolvedor, quero rodar a stack com Docker Compose.
- Como desenvolvedor, quero backend organizado em `app/Modules`.
- Como desenvolvedor, quero contratos de API claros para manter o frontend desacoplado.

---

## Success Metrics

1. Alcançar pelo menos 80% de lancamentos registrados em ate 24 horas apos o evento financeiro.
2. Alcançar pelo menos 60% de membros ativos usando o canal WhatsApp semanalmente.
3. Manter divergencia de saldo manual inferior a 2% nas contas utilizadas no MVP.
4. Permitir conclusao do onboarding inicial da familia em ate 15 minutos por um administrador.
5. Garantir que o fluxo de consulta de saldo via WhatsApp responda em ate 5 segundos em 95% dos casos.

---

## Assumptions and Dependencies

### Assumptions

- O MVP atendera uma familia por contexto principal, mesmo que o modelo possa evoluir.
- O WhatsApp sera um canal operacional prioritario desde a primeira release util.
- O frontend Vue sera distribuido como aplicacao separada do backend Laravel.

### Dependencias

- Disponibilidade do WAHA e sua configuracao de sessao.
- Definicao da biblioteca ou estrategia de JWT no Laravel.
- Disponibilidade de infraestrutura local com Docker.
- Definicao do mecanismo de fila para jobs assincronos.

### Restricoes

- O backend deve seguir organizacao modular em `app/Modules`.
- O ambiente local deve privilegiar containers para servicos principais.
- A automacao por IA nao pode comprometer a confiabilidade do saldo no MVP.

---

## Out of Scope

- Open banking e sincronizacao automatica com bancos.
- Orcamento avancado, metas financeiras e previsoes.
- Relatorios analiticos avancados e dashboards executivos sofisticados.
- Multiempresa ou multi-organizacao fora do contexto familiar.
- Persistencia automatica de lancamentos baseada apenas em IA sem confirmacao.

---

## Planejamento de Releases

### Release 1: Fundacao operacional do MVP

**Escopo:**
- autenticacao JWT;
- familias, membros, bancos e contas;
- lancamentos manuais via web;
- consulta de saldo;
- estrutura modular em Laravel;
- stack local com Docker Compose.

### Release 2: WhatsApp operacional

**Escopo:**
- integracao WAHA;
- webhook seguro;
- consulta de saldo via WhatsApp;
- fluxo guiado para despesa e receita;
- auditoria de conversas.

### Release 3: Assistencia inteligente inicial

**Escopo:**
- ingestao de imagem;
- sugestao de campos por IA;
- confirmacao humana antes da persistencia;
- melhorias de observabilidade e resiliencia.

---

## Riscos e Mitigacoes

| Risco | Impacto | Probabilidade | Mitigacao |
|------|---------|---------------|-----------|
| Erro de classificacao por IA gerar sugestao ruim | Alto | Media | Exigir confirmacao humana e exibir resumo antes de persistir |
| Fluxo conversacional ficar confuso em mensagens ambíguas | Alto | Media | Implementar maquina de estados simples e comandos de cancelar ou reiniciar |
| Acoplamento excessivo entre modulos Laravel | Medio | Media | Definir contratos por modulo e revisar fronteiras na arquitetura |
| Integracao WAHA falhar ou oscilar | Alto | Media | Persistir eventos, usar retentativa e observabilidade de webhook |
| Ambiente Docker divergir do ambiente real de desenvolvimento | Medio | Media | Padronizar `.env`, healthchecks e documentacao operacional |

---

## Traceability Matrix

| Objetivo | Requisitos Relacionados |
|----------|-------------------------|
| Centralizar o controle financeiro familiar | FR-001, FR-002, FR-004, FR-005, FR-008 |
| Reduzir atrito de registro | FR-006, FR-007, FR-010, FR-012 |
| Operar pelo WhatsApp com seguranca | FR-003, FR-009, FR-010, FR-011, NFR-001, NFR-002 |
| Sustentar evolucao tecnica do produto | FR-014, FR-015, FR-016, NFR-007, NFR-009, NFR-010 |

---

## Handoff para Arquitetura

### Decisoes que a arquitetura precisa detalhar

1. Estrutura interna de cada modulo em `app/Modules`.
2. Estrategia de JWT, refresh token, revogacao e middleware.
3. Modelo de persistencia para familias, membros, contas, lancamentos e conversas.
4. Maquina de estados para fluxos de WhatsApp.
5. Filas, jobs e armazenamento de midias para processamento assistido.
6. Contrato REST entre backend Laravel e frontend Vue.
7. Composicao do `docker-compose` para backend, frontend, banco, fila e WAHA.

### Decisao BMAD recomendada

O proximo passo natural e `bmad:architecture`, pois o PRD define um produto de nivel 2 com modulos e integracoes suficientes para exigir desenho tecnico explicito antes do sprint planning.

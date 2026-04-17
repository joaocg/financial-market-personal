# Product Brief: Financeiro Familiar com WhatsApp

- **Date:** 2026-04-17
- **Author:** Codex + Joao Coelho
- **Status:** Draft
- **Version:** 0.1

---

## 1. Resumo Executivo

O projeto `Financeiro` sera uma plataforma de gestao financeira familiar com backend em Laravel, frontend em Vue e interacao transacional via WhatsApp usando WAHA. O objetivo e permitir que uma familia cadastre seus membros, contas e bancos, acompanhe saldos e realize lancamentos financeiros tanto pela interface web quanto por mensagens no WhatsApp.

O diferencial central do produto e transformar o WhatsApp em um canal operacional de baixa friccao. Em vez de depender apenas de telas administrativas, membros da familia poderao consultar saldo, registrar despesas e informar creditos diretamente por conversa. Quando houver imagem de comprovante ou print, a IA ajudara a classificar e sugerir o lancamento.

**Pontos-chave:**
- Problema: familias controlam dinheiro de forma fragmentada, manual e sem colaboracao simples entre membros.
- Solucao: sistema financeiro familiar com operacao web e conversacional via WhatsApp.
- Usuarios-alvo: administradores da familia e membros convidados.
- Horizonte inicial: MVP com cadastro, saldos, transacoes e fluxo conversacional guiado.

---

## 2. Problema

### O problema

Muitas familias usam planilhas, mensagens soltas, aplicativos individuais ou anotacoes informais para controlar despesas, recebimentos e saldos. Isso dificulta a visibilidade financeira compartilhada, gera erros de classificacao e aumenta o esforco para registrar movimentacoes no momento em que elas acontecem.

### Quem sofre com isso

**Usuarios principais:**
- Responsavel financeiro da familia
- Conjuge ou co-gestor familiar
- Membro adulto com acesso a contas e lancamentos

**Usuarios secundarios:**
- Dependentes com acesso restrito
- Contador ou consultor eventual

### Situacao atual

Hoje o controle costuma acontecer em canais separados: banco, bloco de notas, planilha e WhatsApp. O registro financeiro nao acompanha o comportamento real do usuario, que naturalmente prefere mandar uma mensagem rapida ou enviar um print do comprovante.

**Principais dores:**
- Dificuldade para centralizar saldos de varias contas.
- Baixa disciplina para registrar despesas no momento em que ocorrem.
- Falta de padronizacao e visibilidade entre membros da mesma familia.

### Impacto e urgencia

Se isso nao for resolvido, a familia segue com baixa confiabilidade nas informacoes, conciliacao manual e atraso na tomada de decisao financeira. A urgencia e alta porque o WhatsApp ja e um canal natural de uso diario, e integrar esse comportamento ao sistema pode aumentar bastante a adesao.

---

## 3. Usuarios-alvo

### Persona 1: Administrador da familia
- **Papel:** cria a familia, convida membros, define acessos e acompanha o consolidado financeiro.
- **Objetivos:** ter visao geral de saldo, contas, lancamentos e participacao dos membros.
- **Dores:** gasta tempo cobrando informacoes e consolidando dados manualmente.
- **Perfil tecnico:** medio.
- **Uso esperado:** uso frequente pelo painel web e consultas rapidas pelo WhatsApp.

### Persona 2: Membro operacional
- **Papel:** registra despesas, informa recebimentos e consulta saldo.
- **Objetivos:** fazer lancamentos de forma simples e rapida.
- **Dores:** esquece de registrar no app quando o fluxo exige muitos campos.
- **Perfil tecnico:** baixo a medio.
- **Uso esperado:** predominante via WhatsApp, com uso eventual do web.

### Necessidades principais

**Obrigatorias no MVP:**
- Criar familia e adicionar membros com idioma individual.
- Cadastrar bancos e contas bancarias com saldo inicial.
- Registrar transacoes, despesas e creditos.

**Importantes no MVP ou logo apos:**
- Consultar saldo geral e por conta via WhatsApp.
- Interpretar texto e imagem para sugerir ou efetuar lancamentos.

**Pode ficar para depois:**
- Regras avancadas de orcamento.
- Relatorios analiticos e previsoes.

---

## 4. Solucao Proposta

### Visao geral

A aplicacao tera dois canais desacoplados:

1. **Backend API em Laravel**
   Responsavel por autenticacao JWT, regras de negocio, modulos financeiros, integracao com WAHA e processamento de IA.

2. **Frontend em Vue**
   Responsavel por onboarding da familia, painel financeiro, cadastros e consulta estruturada.

3. **Canal conversacional via WhatsApp + WAHA**
   Responsavel por capturar mensagens, iniciar fluxos, consultar saldo e registrar movimentacoes.

### Capacidades principais

1. **Gestao de familia e membros**
   - Criar familia.
   - Convidar usuarios por e-mail e WhatsApp.
   - Definir idioma por membro.
   - Associar membros a uma ou mais familias no futuro, se necessario.

2. **Estrutura financeira**
   - Cadastrar bancos.
   - Cadastrar contas bancarias.
   - Definir saldo inicial igual a zero ou valor informado.

3. **Motor de lancamentos**
   - Registrar transacoes.
   - Registrar despesas.
   - Registrar recebimentos de credito.
   - Manter historico por conta e por familia.

4. **Operacao via WhatsApp**
   - Receber mensagens de membros autorizados.
   - Perguntar o que o usuario deseja fazer.
   - Permitir consulta de saldo total ou por conta.
   - Guiar o usuario no registro de receita ou despesa.

5. **Assistencia por IA**
   - Analisar print ou comprovante enviado.
   - Inferir se a movimentacao parece credito ou debito.
   - Extrair valor, data e descricao quando possivel.
   - Pedir confirmacao quando houver ambiguidade.

### Proposta de valor

O produto une controle financeiro familiar e operacao conversacional em um unico fluxo. O valor nao esta apenas em armazenar dados, mas em reduzir atrito no momento do registro financeiro.

### MVP sugerido

**Escopo do MVP:**
- Cadastro de familia e membros.
- Idioma por membro.
- Cadastro de bancos e contas.
- Saldo inicial por conta.
- Lancamento manual de credito e despesa.
- Consulta de saldo geral e por conta via WhatsApp.
- Recebimento de webhook do WAHA e fluxo conversacional basico.
- Autenticacao JWT.

**Fica para a fase seguinte:**
- OCR e classificacao automatica mais avancada por IA.
- Categorias automaticas.
- Relatorios, metas e dashboards preditivos.

---

## 5. Regras de negocio iniciais

- Toda conta bancaria pertence a uma familia.
- Todo usuario participante deve estar associado a uma familia.
- Cada membro possui um idioma preferencial independente.
- Apenas membros autorizados podem interagir com o numero do WhatsApp da familia.
- Toda movimentacao precisa impactar uma conta bancaria.
- Despesa reduz saldo e credito aumenta saldo.
- Quando a IA nao tiver confianca suficiente, o sistema deve pedir confirmacao antes de persistir.

---

## 6. Arquitetura inicial recomendada

### Backend
- Laravel 13 como API.
- Estrutura modular em `app/Modules`.
- JWT para autenticacao da interface web e APIs internas.
- Webhook controller dedicado para eventos do WAHA.
- Jobs/queues para processamento de imagem e IA.

### Frontend
- Aplicacao Vue separada do backend.
- Consumo de API REST do Laravel.
- Foco inicial em telas administrativas e operacionais.

### Infraestrutura
- Docker Compose na raiz do projeto para subir:
  - `laravel` com PHP/Nginx ou PHP integrado
  - `waha`
  - `postgres` somente se o WAHA realmente precisar para o modo escolhido
- MySQL do macOS como banco principal do Laravel.

### Integracao WhatsApp
- WAHA em container dedicado.
- Laravel recebendo webhooks do WAHA.
- Laravel decidindo fluxo, contexto e resposta.
- WAHA apenas como camada de transporte/comunicacao.

---

## 7. Riscos e decisoes importantes

### Riscos
- Interpretacao automatica de imagens pode gerar lancamentos incorretos.
- Fluxo conversacional sem controle de estado pode ficar confuso.
- Uso de MySQL fora do Docker exige cuidado com rede e credenciais no container Laravel.
- Integrar muita inteligencia logo no inicio pode atrasar o MVP.

### Decisoes recomendadas
- Comecar com fluxo guiado e confirmacoes explicitas no WhatsApp.
- Tratar IA como assistente de classificacao, nao como autoridade final no MVP.
- Subir primeiro backend + WAHA + fluxo basico antes do frontend completo.
- Organizar o dominio por modulos desde o inicio.

---

## 8. Proximo passo recomendado

O melhor proximo passo no BMAD e gerar o `PRD`, quebrando este produto em modulos, requisitos funcionais, requisitos nao funcionais, fluxos e releases:

- `bmad:prd`

Depois disso, os proximos passos naturais sao:

- `bmad:ux-design`
- `bmad:architecture`
- `bmad:sprint-plan`

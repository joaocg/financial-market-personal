# Priorizacao de Escopo: Proximo Ciclo do MVP

- **Projeto:** Financeiro Familiar com WhatsApp
- **Data:** 2026-04-17
- **Autor:** Codex + Joao Coelho
- **Metodo:** MoSCoW com corte pragmatico para destravar adocao do produto

## Resumo Executivo

O MVP concluiu a base tecnica de autenticacao, onboarding, ledger, fluxo guiado no WhatsApp e a primeira superficie Vue de leitura. Os principais bloqueios para avancar do estado "funciona tecnicamente" para "produto utilizavel" agora sao operacionais e administrativos:

1. o WAHA ainda depende de configuracao manual pouco clara de sessao e credenciais;
2. o frontend Vue ainda nao permite cadastrar bancos e contas pela interface;
3. o numero WhatsApp autorizado do membro ainda nao possui fluxo administrativo claro no painel;
4. falta um fluxo de validacao ponta a ponta que prove que credenciais, webhook, contato autorizado e lancamento conversacional funcionam juntos.

## Escopos Priorizados

### Must Have

#### 1. Operacao local do WAHA com credenciais e sessao documentadas

- **Story candidata:** `STORY-016`
- **Motivo:** sem esse escopo, o canal conversacional continua dependente de setup manual e conhecimento tacito.
- **Impacto:** destrava testes reais de WhatsApp e reduz risco operacional do MVP.

#### 2. Cadastro de bancos e contas pelo frontend Vue

- **Story candidata:** `STORY-017`
- **Motivo:** hoje o backend suporta o cadastro, mas o produto web ainda nao fecha o fluxo administrativo principal.
- **Impacto:** reduz dependencia de chamadas manuais a API e torna o onboarding financeiro utilizavel.

#### 3. Gestao de contato WhatsApp autorizado no frontend

- **Story candidata:** `STORY-018`
- **Motivo:** o fluxo conversacional depende de `member_contacts`, mas esse cadastro ainda nao esta exposto de forma clara para operacao normal.
- **Impacto:** conecta onboarding de membros com uso real do WAHA.

### Should Have

#### 4. Smoke test operacional do fluxo WAHA -> webhook -> conversa -> ledger

- **Story candidata:** `STORY-019`
- **Motivo:** depois de configurar o canal e o contato, ainda precisamos de uma validacao repetivel para evitar regressao silenciosa.
- **Impacto:** aumenta confianca para demos, homologacao e manutencao local.

### Could Have

#### 5. Ingestao inicial de imagem para assistencia por IA

- **Story candidata:** `STORY-015`
- **Motivo:** continua alinhada ao produto, mas ainda nao remove os bloqueios mais imediatos de adocao do MVP.
- **Impacto:** agrega valor, porem deve vir depois da estabilizacao operacional e administrativa.

## Sequencia Recomendada

1. `STORY-016` - estabilizar WAHA, segredo, sessao e runbook local.
2. `STORY-017` - habilitar cadastro de bancos e contas no frontend.
3. `STORY-018` - habilitar contato WhatsApp autorizado para membros.
4. `STORY-019` - fechar smoke test ponta a ponta do fluxo conversacional.

## Proposta de Sprint Seguinte

- **Sprint sugerida:** Sprint 4
- **Capacidade de referencia:** 20 pontos
- **Escopo recomendado:** `STORY-016` (5), `STORY-017` (5), `STORY-018` (5), `STORY-019` (3)
- **Total:** 18 pontos
- **Margem operacional:** 2 pontos

## Racional de Priorizacao

- O frontend administrativo tem alto valor de negocio porque elimina atrito de uso e torna o MVP menos dependente de suporte tecnico.
- O WAHA precisa sair do estado de dependencia implicita de configuracao local para um estado repetivel e verificavel.
- O contato WhatsApp do membro e um elo critico entre onboarding da familia e operacao conversacional.
- O smoke test fecha a lacuna entre entrega por modulo e confianca de produto integrado.

## Fora do Corte Imediato

- IA de imagem e comprovantes
- relatorios e extratos mais densos
- conciliacao avancada
- refinamentos visuais nao ligados a onboarding administrativo ou conversa

## Recomendacao Final

O proximo corte de escopo deve focar em **operacionalizar o WhatsApp** e **completar a administracao basica no frontend**. Isso maximiza valor percebido, reduz suporte manual e prepara o terreno para IA e automacoes futuras sem ampliar a superficie de risco antes da hora.

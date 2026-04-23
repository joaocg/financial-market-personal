# Especificacao Tecnica: STORY-015 OCR-first para comprovantes

- **Nome do Projeto:** Financeiro Familiar com WhatsApp
- **Versao:** 0.1
- **Data:** 2026-04-17
- **Autor:** Codex + Joao Coelho
- **Status:** Draft

---

## Visao Geral

### Problema

O produto ja possui fluxo conversacional funcional via WhatsApp e operacao administrativa basica no frontend, mas ainda nao consegue interpretar comprovantes de imagem com custo previsivel e dependencia minima de IA generativa.

### Solucao Proposta

Implementar um pipeline `OCR first, IA fallback` para imagens de comprovantes:

1. receber a imagem enviada pelo usuario;
2. armazenar a midia e registrar a solicitacao de analise;
3. extrair texto com OCR local;
4. classificar a movimentacao com regras e parser heuristico;
5. retornar sugestao estruturada com nivel de confianca;
6. recorrer a IA apenas quando o OCR ou a classificacao ficarem ambiguos.

### Objetivos

- reduzir custo e dependencia de provider externo para leitura de comprovantes;
- extrair valor suficiente de comprovantes comuns de pagamento, deposito e transferencia;
- manter confirmacao humana obrigatoria antes de gravar qualquer lancamento.

---

## Escopo

### Dentro do Escopo

- OCR local para imagens de comprovantes
- extracao de texto bruto, valor, data, descricao e tipo sugerido
- classificacao inicial entre `pagamento`, `deposito`, `transferencia` e `desconhecido`
- fallback opcional para IA somente em casos ambiguos
- resposta estruturada ao modulo de mensagens para confirmacao humana

### Fora do Escopo

- automacao de gravacao sem confirmacao
- treinamento de modelo profundo proprio na primeira iteracao
- suporte amplo a PDFs multipagina ou lotes de documentos
- conciliacao automatica de comprovante com transacoes historicas

---

## Requisitos

### Requisitos Funcionais

#### FR-001: OCR de comprovante [MUST]

O sistema deve extrair texto legivel de uma imagem enviada pelo usuario usando OCR local ou embarcado no ambiente do projeto.

**Acceptance Criteria:**
- o pipeline aceita ao menos imagens `jpg`, `jpeg` e `png`
- o OCR retorna texto bruto armazenavel para depuracao e auditoria
- o processamento falha de forma segura quando a imagem nao puder ser lida

---

#### FR-002: Classificacao heuristica da movimentacao [MUST]

O sistema deve classificar o comprovante, com base no texto extraido, em `pagamento`, `deposito`, `transferencia` ou `desconhecido`.

**Acceptance Criteria:**
- a classificacao usa palavras-chave, regex e score heuristico
- o retorno inclui tipo sugerido e confianca
- quando a confianca for baixa, o resultado fica marcado como ambiguo

---

#### FR-003: Fallback para IA sob ambiguidade [SHOULD]

O sistema deve acionar IA apenas quando o OCR ou a classificacao heuristica nao produzirem sugestao confiavel.

**Acceptance Criteria:**
- o fallback so ocorre abaixo de um limiar de confianca configuravel
- a requisicao para IA recebe o texto OCR e metadados relevantes, nao a imagem bruta por padrao
- o retorno da IA nao elimina a exigencia de confirmacao humana

---

## Requisitos Nao Funcionais

#### NFR-001: Performance [SHOULD]

O processamento de uma imagem simples deve concluir em tempo aceitavel para conversa assíncrona no WhatsApp.

**Target:** OCR + parser heuristico concluindo em ate 10 segundos na maioria dos comprovantes locais

---

#### NFR-002: Seguranca [MUST]

Imagens, textos extraidos e sugestoes nao devem vazar entre familias nem para clientes nao autenticados.

**Requirements:**
- midia e resultados ficam vinculados ao contexto da familia e da solicitacao
- dados sensiveis podem ser mascarados em logs e mensagens de debug

---

#### NFR-003: Escalabilidade [SHOULD]

O pipeline deve rodar de forma assíncrona e tolerante a retries, sem bloquear o webhook de entrada.

**Target Load:** multiplas analises enfileiradas por worker Laravel sem bloquear o recebimento de eventos

---

## Abordagem Tecnica

### Visao Arquitetural

O pipeline recomendado para a `STORY-015` e:

1. `Messaging Module` recebe evento com imagem ou referencia de midia
2. `AI Module` registra uma `analysis request`
3. worker executa preprocessamento da imagem
4. motor OCR local extrai texto bruto
5. parser heuristico detecta:
   - valor monetario
   - data/hora
   - instituicao
   - descricao curta
   - tipo de movimentacao
6. se a confianca ficar abaixo do limite, aciona fallback de IA
7. `BuildSuggestionSummary` devolve sugestao para confirmacao no WhatsApp

### Tecnologias Principais

- `PaddleOCR` ou `Tesseract`: OCR local para leitura de comprovantes
- `Laravel Queue`: processamento assíncrono da analise
- `PHP parser heuristico`: classificacao inicial por regex, dicionarios e score

### Componentes

#### Componente 1: OCR Pipeline

**Purpose:** receber a imagem e produzir texto bruto confiavel o suficiente para classificacao.

**Responsibilities:**
- preprocessar imagem quando necessario
- executar OCR e persistir texto bruto

**Interfaces:**
- `AnalyzeReceiptImage`
- `OcrReceiptImage`

---

#### Componente 2: Receipt Classifier

**Purpose:** transformar texto OCR em uma sugestao estruturada de lancamento.

**Responsibilities:**
- identificar valor, data, descricao e tipo
- calcular score de confianca por campo e score geral

**Interfaces:**
- `ClassifyReceiptText`
- `BuildSuggestionSummary`

---

### Modelo de Dados

#### Entidade 1: ai_analysis_requests

```text
id
family_id
membership_id
channel
source_message_event_id
media_path
status
requested_at
processed_at
```

#### Entidade 2: ai_analysis_results

```text
id
request_id
ocr_text
suggested_type
suggested_amount
suggested_date
suggested_description
confidence_score
confidence_breakdown_json
fallback_used
raw_provider_response
```

### Design de API Interna

#### Endpoint/Action 1: `AnalyzeReceiptImage`
**Method:** Job/Action interna  
**Purpose:** disparar o pipeline assíncrono de OCR e classificacao

**Request:**
```json
{
  "family_id": "uuid",
  "membership_id": "uuid",
  "media_path": "receipts/2026/04/file.jpg",
  "source_message_event_id": "uuid"
}
```

**Response:**
```json
{
  "request_id": "uuid",
  "status": "queued"
}
```

---

#### Endpoint/Action 2: `BuildSuggestionSummary`
**Method:** Action interna  
**Purpose:** gerar resumo seguro para confirmacao no WhatsApp

**Request:**
```json
{
  "request_id": "uuid"
}
```

**Response:**
```json
{
  "suggested_type": "pagamento",
  "suggested_amount": "149.90",
  "suggested_date": "2026-04-17",
  "suggested_description": "Pagamento Pix",
  "confidence_score": 0.86,
  "fallback_used": false
}
```

---

## Consideracoes de Implementacao

### Padroes de Design

- `Pipeline`: separar OCR, parser e fallback de IA em etapas independentes
- `Strategy`: permitir trocar engine OCR sem reescrever o fluxo

### Tratamento de Erros

Erros de OCR, imagem corrompida ou classificacao insuficiente devem resultar em retorno seguro do tipo "nao consegui interpretar com confianca". O sistema deve oferecer continuidade manual do fluxo, em vez de persistir dados duvidosos.

### Logging e Monitoramento

Registrar:

- tempo de OCR
- tamanho da imagem
- score final de confianca
- uso ou nao do fallback de IA
- motivo da classificacao `desconhecido`

**Metricas principais:**
- percentual de comprovantes resolvidos sem IA
- taxa de fallback para IA
- taxa de sugestoes confirmadas pelo usuario

### Gestao de Configuracao

Sugestao de configuracoes:

- `RECEIPT_OCR_DRIVER=paddleocr|tesseract`
- `RECEIPT_AI_FALLBACK_ENABLED=true|false`
- `RECEIPT_AI_FALLBACK_CONFIDENCE_THRESHOLD=0.70`
- `RECEIPT_ALLOWED_MIME_TYPES=image/jpeg,image/png`

---

## Estrategia de Testes

### Unit Testing
**Coverage Target:** 80%

**Focus Areas:**
- parser heuristico de valor, data e tipo
- score de confianca e regra de fallback

### Integration Testing
**Scenarios:**
1. comprovante de pagamento com OCR suficiente e sem IA
2. comprovante de deposito com OCR suficiente e sem IA
3. comprovante ambiguo que ativa fallback de IA

### Performance Testing
**Load Profile:** pequeno volume de comprovantes em ambiente local com processamento assíncrono por worker unico

**Success Criteria:**
- pipeline nao bloqueia webhook
- sugestao final fica disponivel em tempo compativel com conversa assíncrona

---

## Recomendacao de Stack

Para a primeira iteracao, a melhor ordem pratica e:

1. começar com `Tesseract` se quiser bootstrap simples e baixo atrito;
2. preferir `PaddleOCR` se a qualidade do OCR em comprovantes for decisiva desde o inicio;
3. manter o classificador em heuristicas antes de treinar qualquer modelo;
4. usar IA generativa apenas como fallback sob baixa confianca.

## Decisao Recomendada

Para este projeto, eu recomendo:

- `OCR`: `PaddleOCR` como alvo ideal, com `Tesseract` como alternativa de menor atrito
- `classificacao`: parser heuristico em PHP
- `fallback`: provider de IA externo opcional, acionado apenas sob limiar baixo de confianca

Isso maximiza controle de custo, reduz dependencia externa e preserva um caminho claro para evoluir depois para modelos mais fortes, se o volume de comprovantes justificar.

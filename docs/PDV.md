# Configurar uma subcampanha com PDV

## Pré requisitos
1. Via Backoffice, ativar o módulo "Execução (PDV)"
2. Via Plataform, criar uma nova subcampanha (Gerencial -> campanhas -> nova campanha)
    - A opção **Campanha de execução de PDV** deve ficar ativa
    - É necessário configurar também a **identidade visual** da campanha

## Configurações do PDV
1. Configure pelo menos um período 
2. Dentro do período, configure a mecânica, as postagens, os campos extras e a ordenação dos campos 
    - Em mecânica, habilite a opção **rolo de câmera**
3. Com essa configuração mínima, já é possível postar fotos via Banking

## Réplica de configurações PDV entre períodos

### Objetivo
Permitir replicar a configuração de PDV de um período de origem para um período de destino já criado, reduzindo retrabalho operacional e evitando erro manual em cadastros recorrentes.

### Fluxo
1. Criar o novo período normalmente
2. Acessar a tela de detalhe do período novo
3. Clicar em **Replicar Configurações PDV**
4. Selecionar a mecânica da réplica
5. Selecionar o período de origem
6. Confirmar a réplica

### Regra de mecânica
- a mecânica é escolhida na própria tela de réplica
- o período de origem é filtrado pela mesma mecânica selecionada
- a réplica só pode ocorrer entre períodos da mesma mecânica
- a estrutura foi preparada para suportar novas mecânicas por `pdv_type_execution.key`

### Regras principais
- o período destino é sempre o período aberto na tela
- o período de origem deve ser da mesma subcampanha
- a origem deve possuir configuração válida para a mesma mecânica selecionada
- o destino não pode possuir configuração iniciada para a mecânica da réplica
- a operação ocorre em transação única
- se qualquer etapa falhar, nada deve ser salvo no destino

### Estrutura replicada em Execução por Tipos
- `pdv_mechanics_config`
- `pdv_mechanics_types`
- `pdv_mechanics_subtypes`
- `pdv_mechanics_subtypes_options`
- `pdv_photo_post_config`
- `pdv_extra_fields_config`
- `pdv_extra_fields_config_segregation`
- `pdv_order_section_fields`
- `pdv_ia_config`

### Regra importante sobre IDs
Na réplica estrutural, tipos, subtipos e opções são recriados no destino com novos IDs.

Por isso:
- a configuração de IA não pode reutilizar IDs da origem
- a réplica monta mapas de IDs antigos para novos
- `pdv_ia_config` é gravada no destino usando apenas os novos IDs gerados na réplica

### Comportamento em caso de erro
Se houver qualquer inconsistência, especialmente em remapeamento de tipo, subtipo ou opção da IA, a operação executa rollback completo e nenhuma informação parcial permanece salva no período destino.

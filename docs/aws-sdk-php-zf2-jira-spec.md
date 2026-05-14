# Análise de Atualização do Pacote `aws/aws-sdk-php-zf2`

## Objetivo

Documentar a análise inicial e a análise complementar sobre a possibilidade de atualizar o pacote Composer `aws/aws-sdk-php-zf2`, considerando:

- compatibilidade com o stack atual
- risco de quebra no sistema
- impacto nos fluxos de upload, download, listagem e cron
- relação com a migração para Oracle Object Storage

---

## Contexto do apontamento original

- Severidade: BAIXA
- Arquivo: `composer.json`
- Pacote: `aws/aws-sdk-php-zf2`
- Versão atual: `2.1.0`
- Versão segura apontada: `4.5.0`
- Observação original: pacote significativamente desatualizado, vinculado ao ZF2, com indicação de correção junto da migração `ZF2 -> Laminas`

---

## Análise 1

### Conclusão inicial

A atualização de `aws/aws-sdk-php-zf2` para `4.5.0` não é compatível com o stack atual do sistema.

O projeto utiliza:

- `zendframework/zendframework: 2.4.13`
- `aws/aws-sdk-php-zf2: 2.1.0`

A versão `4.5.0` do pacote exige:

- `PHP >= 8.1`
- `laminas/laminas-filter`
- `laminas/laminas-servicemanager`
- `laminas/laminas-session`
- `laminas/laminas-view`

Isso significa que a versão `4.5.0` depende de um stack baseado em Laminas e não é instalável de forma segura no ambiente atual sem migração estrutural do framework.

### Conclusão adicional

A versão `3.0.0` também não fecha com a stack atual, porque exige `zendframework/zend-servicemanager 2.7.* || 3.*`, enquanto o projeto está em `Zend Framework 2.4.13`.

Portanto:

- a maior versão compatível com a stack atual é a própria `2.1.0`

### Importante: uso real no sistema

O projeto não aparenta depender do módulo `AwsModule` fornecido pelo pacote `aws/aws-sdk-php-zf2`.

Em vez disso, usa:

- módulo próprio `Amazon`
- serviços próprios em `module/Amazon`
- uso direto de `Aws\S3\S3Client`

Arquivos relevantes:

- `config/application.config.php`
- `module/Amazon/Module.php`
- `module/Amazon/src/Amazon/S3/Service/File/FileService.php`
- `module/Core/src/Core/Helper/AWS.php`
- `module/Core/src/Core/Helper/ObjectStorage.php`

### Mapeamento dos fluxos informados

#### 1. Rota `/Plataform/Banner/index`

Considerando a correção de contexto, essa rota deve ser lida pelo fluxo padrão Proponto/Mirante.

Arquivo principal:

- `module/AppPlataform/src/AppPlataform/Service/Proponto/BannerService.php`

Conclusões:

- a listagem trata banners salvos tanto em AWS quanto em Oracle Object Storage
- quando o banner está em Oracle, a rota gera URL privada por `ObjectStorage`
- quando o banner está em AWS, a rota gera URL privada por `Core\Helper\AWS`
- no save do banner, o fluxo atual prioriza `ObjectStorage`, com comentários indicando fluxo antigo em AWS

Ou seja:

- essa rota é, sim, relevante para a análise
- ela mostra coexistência entre storage AWS e Oracle no fluxo padrão

#### 2. Rota `/Plataform/FileImport/resaleLinkImport`

Esse fluxo usa upload para storage S3.

Caminho identificado:

- `FileImportResaleService::resaleLinkImportAction()`
- `FileImportService::save()`
- `FileImportService::saveFileAWS()`
- `Core\Helper\AWS::upload()`

Conclusão:

- o upload acontece usando `Aws\S3\S3Client` por helper próprio

#### 3. Rota `/Plataform/FileImport/resaleLinkDetail?import_id=21320`

O download do arquivo original usa:

- `FileImportService::exportOriginal()`
- `Core\Helper\AWS::download()` ou `Core\Helper\AWS::downloadNew()`

Conclusão:

- o download também passa por helper próprio baseado em `Aws\S3\S3Client`

#### 4. Cron de processamento de file import

O processamento de vínculos usa:

- `AppCron\Controller\FileImport\ResaleController::processResaleLinkPropontoAction()`
- `Import\Service\Resale\Proponto\ProcessResaleLinkService`
- leitura do arquivo via `Core\Helper\AWS::getExcelData()`

Conclusão:

- o processamento também depende do helper próprio e do SDK base

### Consideração sobre Oracle Object Storage

O projeto já possui uso de Oracle Object Storage com endpoint S3-compatible.

Configuração localizada em:

- `config/autoload/global.php`
- `config/autoload/local.example.php`

Implementação localizada em:

- `module/Core/src/Core/Helper/ObjectStorage.php`

Conclusão:

- a migração para Oracle reforça que o componente estratégico é o SDK base `aws/aws-sdk-php`
- o bridge `aws/aws-sdk-php-zf2` não é o elemento central dessa compatibilidade
- no fluxo padrão Proponto/Mirante, a camada de Banner já contempla AWS e Oracle no mesmo serviço

### Recomendação da Análise 1

Não executar a task como simples update de Composer para `4.5.0`.

Abrir tasks separadas se a meta for chegar na versão mais nova:

1. Migração `ZF2 -> Laminas`
2. Revisão e possível remoção de `aws/aws-sdk-php-zf2`
3. Homologação dos fluxos de upload/download/processamento em AWS e Oracle
4. Ajustes de compatibilidade em ACL, presigned URLs e storage helpers

---

## Análise 2

### Pergunta respondida

Qual a última versão compatível com a stack atual, que seja possível atualizar para reduzir risco de segurança?

### Resposta objetiva

A última versão compatível com a stack atual é:

- `aws/aws-sdk-php-zf2: 2.1.0`

Ou seja:

- não existe upgrade viável desse pacote dentro da stack atual

### Justificativa técnica

#### Versão `3.0.0`

Não é compatível porque exige:

- `zendframework/zend-servicemanager 2.7.* || 3.*`

Enquanto o projeto está em:

- `zendframework/zendframework 2.4.13`

#### Versão `4.5.0`

Não é compatível porque exige:

- `PHP >= 8.1`
- `laminas/laminas-filter ^2.9.0`
- `laminas/laminas-servicemanager ^3.0 || ^4.0`
- `laminas/laminas-session ^2.7.0`
- `laminas/laminas-view ^2.8`

Portanto, ela depende de Laminas e não apenas de pequenos ajustes de Composer.

### Conclusão da Análise 2

Se o objetivo for reduzir risco de segurança, atualizar `aws/aws-sdk-php-zf2` não traz ganho prático dentro da stack atual, porque:

- a última versão compatível já é a atual `2.1.0`
- o pacote aparenta não ser o principal ponto de integração real
- o sistema usa majoritariamente `Aws\S3\S3Client` via helpers próprios

### Recomendação prática

Para reduzir risco de segurança, o foco deve ser:

1. Confirmar se `aws/aws-sdk-php-zf2` ainda é necessário
2. Avaliar a remoção do pacote, caso o uso real do `AwsModule` não exista
3. Manter e acompanhar o `aws/aws-sdk-php` base, que é o SDK efetivamente utilizado
4. Planejar migração de framework para Laminas caso a meta seja suportar o bridge moderno

---

## Conclusão consolidada

### Situação atual

- Stack atual: `Zend Framework 2.4.13`
- Pacote analisado: `aws/aws-sdk-php-zf2: 2.1.0`
- Última versão do pacote: `4.5.0`

### Resposta final

- `4.5.0` não é compatível com a stack atual
- `3.0.0` também não é compatível
- a última versão compatível com o que existe hoje é `2.1.0`

### Direcionamento recomendado

Não abrir task de simples upgrade do pacote para `4.5.0`.

Abrir task com uma destas abordagens:

#### Opção A

Task de análise e remoção do `aws/aws-sdk-php-zf2`, caso confirmado que o pacote não é usado em runtime.

#### Opção B

Task maior de modernização:

1. Migrar `ZF2 -> Laminas`
2. Atualizar/remodelar integração AWS
3. Homologar AWS e Oracle Object Storage
4. Ajustar pontos de compatibilidade

---

## Referências

- Packagist:
    - https://packagist.org/packages/aws/aws-sdk-php-zf2
- Repositório oficial:
    - https://github.com/aws/aws-sdk-php-zf2
- Composer do projeto:
    - `composer.json`

---

# Jira Spec - Análise de Atualização do Pacote `aws/aws-sdk-php-zf2`

## Título sugerido

Analisar viabilidade de atualização do pacote `aws/aws-sdk-php-zf2` e impacto nos fluxos AWS/Oracle

## Resumo executivo

Foi realizada análise técnica sobre a atualização do pacote `aws/aws-sdk-php-zf2`, atualmente fixado na versão `2.1.0`.

Conclusão:

- a atualização para a última versão `4.5.0` não é compatível com o stack atual
- a versão `3.0.0` também não é compatível com o stack atual
- a última versão compatível com o ambiente atual é a própria `2.1.0`

O projeto está em:

- `zendframework/zendframework 2.4.13`

E as versões mais novas do pacote exigem:

- `zend-servicemanager` mais novo, a partir da linha `3.0.0`
- stack `Laminas`, a partir da linha `4.x`

Adicionalmente, a análise indicou que o sistema não depende principalmente do bridge `aws/aws-sdk-php-zf2`, mas sim de:

- módulo próprio `Amazon`
- helpers próprios com `Aws\S3\S3Client`
- integração S3-compatible para Oracle Object Storage

## Objetivo da task

Formalizar a conclusão técnica sobre a impossibilidade de upgrade simples do pacote `aws/aws-sdk-php-zf2` e definir o encaminhamento correto para redução de risco e futura modernização.

## Resultado esperado

- documentar que `aws/aws-sdk-php-zf2 4.5.0` não é compatível com a stack atual
- documentar que `aws/aws-sdk-php-zf2 3.0.0` também não é compatível
- registrar que a última versão compatível com o ambiente atual é `2.1.0`
- apontar que a redução de risco não será obtida por upgrade simples desse pacote
- indicar necessidade de tasks complementares para remoção do bridge legado ou migração de framework

## Escopo analisado

### Fluxos considerados

1. Salvando na AWS
2. Visualização em listagens
3. Upload de arquivo
4. Processo de `file_import`
5. Download de arquivos
6. Processamento de cron
7. Salvamento em Oracle Object Storage
8. Visualização nas listagens/telas com uso de storage

### Rotas consideradas na análise

- `/Plataform/Banner/index`
- `/Plataform/FileImport/resaleLinkImport`
- `/Plataform/FileImport/resaleLinkDetail?import_id=21320`

## Principais conclusões técnicas

### 1. Compatibilidade do pacote

- versão atual: `2.1.0`
- versão `3.0.0`: não compatível com o stack atual
- versão `4.5.0`: não compatível com o stack atual
- última versão compatível: `2.1.0`

### 2. Dependência real do sistema

O sistema não aparenta depender do módulo `AwsModule` do pacote `aws/aws-sdk-php-zf2` em runtime.

O uso predominante ocorre por:

- `module/Amazon`
- `Core\Helper\AWS`
- `Core\Helper\ObjectStorage`
- uso direto de `Aws\S3\S3Client`

### 3. Impacto por fluxo

#### `/Plataform/Banner/index`

- no fluxo padrão Proponto/Mirante, a listagem trata banners em AWS e Oracle Object Storage
- o serviço padrão gera URL privada para Oracle via `ObjectStorage`
- o serviço padrão gera URL privada para AWS via `Core\Helper\AWS`
- o save atual do banner prioriza Oracle Object Storage, mantendo evidência de fluxo antigo em AWS

#### `/Plataform/FileImport/resaleLinkImport`

- o upload do arquivo usa helper próprio com `Aws\S3\S3Client`

#### `/Plataform/FileImport/resaleLinkDetail`

- o download do arquivo usa helper próprio com `Aws\S3\S3Client`

#### `cron processResaleLinkProponto`

- a leitura e processamento do arquivo usa helper próprio baseado no SDK AWS

#### Oracle Object Storage

- a aplicação já utiliza endpoint S3-compatible da Oracle
- o fluxo padrão de banner já considera AWS e Oracle no mesmo serviço
- isso reforça que a camada crítica é o SDK base e não o pacote bridge ZF2

## Decisão recomendada

### Não executar

Não executar update simples de Composer para:

- `aws/aws-sdk-php-zf2: 3.0.0`
- `aws/aws-sdk-php-zf2: 4.5.0`

### Executar

Registrar que:

- a versão compatível máxima permanece `2.1.0`
- não há upgrade seguro desse pacote dentro do stack atual

## Risco de quebra

### Se tentar atualizar para `3.0.0`

Risco alto de incompatibilidade com componentes Zend atuais, principalmente camada de ServiceManager.

### Se tentar atualizar para `4.5.0`

Risco crítico de quebra, pois depende de:

- Laminas
- compatibilidade com novos pacotes
- revisão estrutural do framework

### Se mantiver `2.1.0`

Risco residual de permanecer com bridge legado, porém sem introduzir quebra operacional imediata.

## Melhor estratégia para reduzir risco

A redução de risco deve seguir uma destas linhas:

### Opção 1

Analisar e remover o pacote `aws/aws-sdk-php-zf2`, se confirmado que ele não é necessário em runtime.

### Opção 2

Planejar uma modernização estrutural com:

1. migração `ZF2 -> Laminas`
2. atualização da integração bridge
3. homologação completa dos fluxos AWS e Oracle

## Critérios de aceite

1. A task deve registrar formalmente que a última versão compatível com a stack atual é `2.1.0`.
2. A task deve registrar que `3.0.0` e `4.5.0` não são compatíveis com o ambiente atual.
3. A task deve apontar que o sistema usa majoritariamente helpers próprios e `Aws\S3\S3Client`.
4. A task deve indicar que redução de risco não será obtida por simples update desse pacote.
5. A task deve sugerir abertura de tasks derivadas para modernização ou remoção do bridge legado.

## Tasks derivadas sugeridas

### Task derivada 1

Analisar se `aws/aws-sdk-php-zf2` pode ser removido do projeto sem impacto funcional

### Task derivada 2

Mapear todos os pontos de uso de `Aws\S3\S3Client`, `Core\Helper\AWS` e `Core\Helper\ObjectStorage`

### Task derivada 3

Planejar migração `Zend Framework 2 -> Laminas`

### Task derivada 4

Homologar fluxos de upload, download e processamento entre AWS S3 e Oracle Object Storage

## Definição de pronto

- documentação validada pela equipe técnica
- direcionamento aprovado entre manter, remover ou substituir o bridge legado
- backlog derivado criado para evolução estrutural
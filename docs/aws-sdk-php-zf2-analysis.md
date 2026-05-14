# Analise de Atualizacao do Pacote `aws/aws-sdk-php-zf2`

## Objetivo

Documentar a analise inicial e a analise complementar sobre a possibilidade de atualizar o pacote Composer `aws/aws-sdk-php-zf2`, considerando:

- compatibilidade com o stack atual
- risco de quebra no sistema
- impacto nos fluxos de upload, download, listagem e cron
- relacao com a migracao para Oracle Object Storage

---

## Contexto do apontamento original

- Severidade: BAIXA
- Arquivo: `composer.json`
- Pacote: `aws/aws-sdk-php-zf2`
- Versao atual: `2.1.0`
- Versao segura apontada: `4.5.0`
- Observacao original: pacote significativamente desatualizado, vinculado ao ZF2, com indicacao de correcao junto da migracao `ZF2 -> Laminas`

---

## Analise 1

### Conclusao inicial

A atualizacao de `aws/aws-sdk-php-zf2` para `4.5.0` nao e compativel com o stack atual do sistema.

O projeto utiliza:

- `zendframework/zendframework: 2.4.13`
- `aws/aws-sdk-php-zf2: 2.1.0`

A versao `4.5.0` do pacote exige:

- `PHP >= 8.1`
- `laminas/laminas-filter`
- `laminas/laminas-servicemanager`
- `laminas/laminas-session`
- `laminas/laminas-view`

Isso significa que a versao `4.5.0` depende de um stack baseado em Laminas, e nao e instalavel de forma segura no ambiente atual sem migracao estrutural do framework.

### Conclusao adicional

A versao `3.0.0` tambem nao fecha com a stack atual, porque exige `zendframework/zend-servicemanager 2.7.* || 3.*`, enquanto o projeto esta em `Zend Framework 2.4.13`.

Portanto:

- a maior versao compativel com a stack atual e a propria `2.1.0`

### Importante: uso real no sistema

O projeto nao aparenta depender do modulo `AwsModule` fornecido pelo pacote `aws/aws-sdk-php-zf2`.

Em vez disso, usa:

- modulo proprio `Amazon`
- servicos proprios em `module/Amazon`
- uso direto de `Aws\S3\S3Client`

Arquivos relevantes:

- `config/application.config.php`
- `module/Amazon/Module.php`
- `module/Amazon/src/Amazon/S3/Service/File/FileService.php`
- `module/Core/src/Core/Helper/AWS.php`
- `module/Core/src/Core/Helper/ObjectStorage.php`

### Mapeamento dos fluxos informados

#### 1. Rota `/Plataform/Banner/index`

Considerando a correcao de contexto, essa rota deve ser lida pelo fluxo padrao Proponto/Mirante.

Arquivo principal:

- `module/AppPlataform/src/AppPlataform/Service/Proponto/BannerService.php`

Conclusoes:

- a listagem trata banners salvos tanto em AWS quanto em Oracle Object Storage
- quando o banner esta em Oracle, a rota gera URL privada por `ObjectStorage`
- quando o banner esta em AWS, a rota gera URL privada por `Core\Helper\AWS`
- no save do banner, o fluxo atual prioriza `ObjectStorage`, com comentarios indicando fluxo antigo em AWS

Ou seja:

- essa rota e sim relevante para a analise
- ela mostra coexistencia entre storage AWS e Oracle no fluxo padrao

#### 2. Rota `/Plataform/FileImport/resaleLinkImport`

Esse fluxo usa upload para storage S3.

Caminho identificado:

- `FileImportResaleService::resaleLinkImportAction()`
- `FileImportService::save()`
- `FileImportService::saveFileAWS()`
- `Core\Helper\AWS::upload()`

Conclusao:

- o upload acontece usando `Aws\S3\S3Client` por helper proprio

#### 3. Rota `/Plataform/FileImport/resaleLinkDetail?import_id=21320`

O download do arquivo original usa:

- `FileImportService::exportOriginal()`
- `Core\Helper\AWS::download()` ou `Core\Helper\AWS::downloadNew()`

Conclusao:

- o download tambem passa por helper proprio baseado em `Aws\S3\S3Client`

#### 4. Cron de processamento de file import

O processamento de vinculos usa:

- `AppCron\Controller\FileImport\ResaleController::processResaleLinkPropontoAction()`
- `Import\Service\Resale\Proponto\ProcessResaleLinkService`
- leitura do arquivo via `Core\Helper\AWS::getExcelData()`

Conclusao:

- o processamento tambem depende do helper proprio e do SDK base

### Consideracao sobre Oracle Object Storage

O projeto ja possui uso de Oracle Object Storage com endpoint S3-compatible.

Configuracao localizada em:

- `config/autoload/global.php`
- `config/autoload/local.example.php`

Implementacao localizada em:

- `module/Core/src/Core/Helper/ObjectStorage.php`

Conclusao:

- a migracao para Oracle reforca que o componente estrategico e o SDK base `aws/aws-sdk-php`
- o bridge `aws/aws-sdk-php-zf2` nao e o elemento central dessa compatibilidade
- no fluxo padrao Proponto/Mirante, a camada de Banner ja contempla AWS e Oracle no mesmo servico

### Recomendacao da Analise 1

Nao executar a task como simples update de Composer para `4.5.0`.

Abrir tasks separadas se a meta for chegar na versao mais nova:

1. Migracao `ZF2 -> Laminas`
2. Revisao e possivel remocao de `aws/aws-sdk-php-zf2`
3. Homologacao dos fluxos de upload/download/processamento em AWS e Oracle
4. Ajustes de compatibilidade em ACL, presigned URLs e storage helpers

---

## Analise 2

### Pergunta respondida

Qual a ultima versao compativel com a stack atual, que seja possivel atualizar para reduzir risco de seguranca?

### Resposta objetiva

A ultima versao compativel com a stack atual e:

- `aws/aws-sdk-php-zf2: 2.1.0`

Ou seja:

- nao existe upgrade viavel desse pacote dentro da stack atual

### Justificativa tecnica

#### Versao `3.0.0`

Nao e compativel porque exige:

- `zendframework/zend-servicemanager 2.7.* || 3.*`

Enquanto o projeto esta em:

- `zendframework/zendframework 2.4.13`

#### Versao `4.5.0`

Nao e compativel porque exige:

- `PHP >= 8.1`
- `laminas/laminas-filter ^2.9.0`
- `laminas/laminas-servicemanager ^3.0 || ^4.0`
- `laminas/laminas-session ^2.7.0`
- `laminas/laminas-view ^2.8`

Portanto, ela depende de Laminas e nao apenas de pequenos ajustes de Composer.

### Conclusao da Analise 2

Se o objetivo for reduzir risco de seguranca, atualizar `aws/aws-sdk-php-zf2` nao traz ganho pratico dentro da stack atual, porque:

- a ultima versao compativel ja e a atual `2.1.0`
- o pacote aparenta nao ser o principal ponto de integracao real
- o sistema usa majoritariamente `Aws\S3\S3Client` via helpers proprios

### Recomendacao pratica

Para reduzir risco de seguranca, o foco deve ser:

1. Confirmar se `aws/aws-sdk-php-zf2` ainda e necessario
2. Avaliar a remocao do pacote, caso o uso real do `AwsModule` nao exista
3. Manter e acompanhar o `aws/aws-sdk-php` base, que e o SDK efetivamente utilizado
4. Planejar migracao de framework para Laminas caso a meta seja suportar o bridge moderno

---

## Conclusao consolidada

### Situacao atual

- Stack atual: `Zend Framework 2.4.13`
- Pacote analisado: `aws/aws-sdk-php-zf2: 2.1.0`
- Ultima versao do pacote: `4.5.0`

### Resposta final

- `4.5.0` nao e compativel com a stack atual
- `3.0.0` tambem nao e compativel
- a ultima versao compativel com o que existe hoje e `2.1.0`

### Direcionamento recomendado

Nao abrir task de simples upgrade do pacote para `4.5.0`.

Abrir task com uma destas abordagens:

#### Opcao A

Task de analise e remocao do `aws/aws-sdk-php-zf2`, caso confirmado que o pacote nao e usado em runtime.

#### Opcao B

Task maior de modernizacao:

1. Migrar `ZF2 -> Laminas`
2. Atualizar/remodelar integracao AWS
3. Homologar AWS e Oracle Object Storage
4. Ajustar pontos de compatibilidade

---

## Referencias

- Packagist:
  - https://packagist.org/packages/aws/aws-sdk-php-zf2
- Repositorio oficial:
  - https://github.com/aws/aws-sdk-php-zf2
- Composer do projeto:
  - `composer.json`

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Visão Geral

Proponto é uma plataforma de fidelidade multi-campanha construída sobre **Zend Framework 2** com arquitetura modular. Cada campanha (ex: Unimed, Canon, Moura, Cury) roda no mesmo código-base, diferenciada por configuração e sobrescrita de classes específicas via `class_suffix`.

## Configuração

1. Copiar `.htaccess` para a raiz do projeto
2. Copiar `local.php` para `config/autoload/` (não versionado)
3. Rodar `composer install`

O `local.php` contém credenciais de banco (Doctrine/PDO) e a configuração de conexão do Eloquent:
```php
'eloquent' => [
    'driver' => 'mysql', 'host' => '...', 'port' => '...', 'database' => '...', 'username' => '...', 'password' => '...'
]
```

## Comandos Principais

### Migrations (phpmig)
```bash
vendor/bin/phpmig generate [NomeDaMigration]   # Criar migration
vendor/bin/phpmig migrate                       # Rodar todas as migrations pendentes
vendor/bin/phpmig up [Timestamp]                # Rodar uma migration específica
vendor/bin/phpmig down [Timestamp]              # Desfazer uma migration específica
```

### Crons
```bash
php public/index.php cron {ROTA_DA_CRON}
```
Rotas de cron são definidas em `module/AppCron/config/module.config.php`. Controllers e services ficam em `module/AppCron/src/AppCron/`.

### Formatação de Código (php-cs-fixer)
```bash
vendor/bin/php-cs-fixer fix .                # Corrigir todos os arquivos
vendor/bin/php-cs-fixer fix caminho/arquivo.php
```
A configuração está em `.php-cs-fixer.php` (base PSR-12 com customizações).

## Arquitetura

### Fluxo dos Módulos
```
App Controller (ex: AppPlataform)
  -> App Service
  -> Service do módulo específico (ex: Consumer, Campaign, Order)
  -> Repository do módulo específico
```

- **Nunca** ler dados de sessão fora dos módulos App — passar como parâmetro.
- **Nunca** retornar objetos grandes do banco na camada pública final — usar arrays ou objetos customizados.
- Métodos estáticos são permitidos apenas nos Repositories dos módulos.

### Tipos de Módulo

- `AppPlataform` — plataforma de fidelidade voltada ao consumidor
- `AppBanking` — interface B2B banking/revendedor
- `AppBackoffice` — admin/backoffice
- `AppSite` — site da campanha
- `AppCron` — jobs agendados
- `AppApi` / `AppApiV2` — API REST
- `Core` — classes base, helpers (`Core\Helper\Util`), repositories, camada REST
- Módulos de negócio: `Account`, `Consumer`, `Campaign`, `Order`, `Points`, `Sales`, `Report`, etc.

### Classes Específicas de Campanha

Campanhas sobrescrevem comportamentos genéricos via `class_suffix` (armazenado em `account_campaign.class_suffix`). Para carregar uma classe específica de campanha:

```php
$classPath = \Core\Helper\Util::getCampaignClassPath('Unimed', 'AppPlataform\Form\\', 'ResaleFilter');
$class = $this->getService($classPath);
```

Services e forms específicos ficam em subpastas nomeadas pelo `class_suffix`, ex: `AppPlataform/src/AppPlataform/Service/Unimed/`.

### Convenções de Migration

- Uma migration por feature/branch
- Nome da classe: PascalCase
- Sempre implementar `up()` e `down()`
- `down()` deve reverter completamente o `up()` (incluindo recriar tabelas removidas)
- Inserts (seeders) vão nas próprias migrations — phpmig não tem ferramenta separada de seeder

### ORM: Doctrine vs. Eloquent

Ambos são utilizados. Doctrine é o ORM principal; Eloquent (Laravel 5.4) está disponível para queries complexas e utiliza o wrapper `Core\Helper\Paginator`. Não chamar `->get()` antes de passar uma query ao `Paginator`.

## Convenções de Nomenclatura

| Escopo | Convenção |
|---|---|
| Classes | PascalCase |
| Métodos e variáveis | camelCase |
| Chaves de array | snake_case |
| Banco de dados / código | Inglês |

## Estilo de Código

- Chaves: sempre obrigatórias (mesmo em `if` de uma linha), abertura na mesma linha em estruturas de controle, nova linha em funções
- Não usar short tags PHP (`<?=`)
- Linha em branco antes de `return`, `if`, `foreach`
- Espaço entre `if`/`foreach` e parênteses

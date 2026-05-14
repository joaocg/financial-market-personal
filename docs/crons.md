# Criando e executando crons

## Criando
1. Crie um novo controller em `module/AppCron/src/AppCron/Controller`
2. Registre o novo controller em `module/AppCron/config/module.config.php` no nó `'controllers' => 'invokables'`
3. Registre sua cron em `module/AppCron/config/module.config.php` no nó `'console' => 'router' => 'routes'` conforme o exemplo abaixo: 
```php
'cron_nome_da_cron' => [
    'options' => [
        'route' => 'cron nomeDaCron',
        'defaults' => [
            'controller' => 'AppCron\Controller\NomeDoController',
            'action' => 'nomeDaFuncao',
            'module' => 'AppCron'
        ]
    ]
],
```
4. Espera-se que seu controller e sua função esteja conforme este exemplo:
```php
<?php
namespace AppCron\Controller;

use Core\Controller\ActionController;

class NomeDoController  extends ActionController
{
    public function nomeDaFuncaoAction()
    {
        exit("Teste de execução de cron");
    }
}
```

## Executando 
1. Entre no terminal do container `cd ~/pp-docker && make bash`
2. Entre na pasta pública do projeto da proponto `cd /var/www/app/proponto/public`
3. Rode o comando `php74 index.php cron nomeDaCron`
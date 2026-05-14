# Criando Rotas

Criar uma nova rota (url, ou página) dentro do nosso projeto significa:

1. Criar uma função `action` no **Controller**
2. Criar o próprio **Controller** se necessário
3. Criar uma função `action` correspondente em um **Service da Proponto**
4. Criar o próprio **Service** se necessário
5. Criar, se necessário, uma **view** (`.phtml`) na pasta correspondente
6. Criar, se necessário, um **migration de ACL** para liberar o acesso

O local específico em que esses arquivos/funções serão criados – e o próprio padrão da URL – depende do contexto.  
Em geral, categorizamos as rotas da seguinte forma:

- **Área não logada do banking**  
  Ex.: `/Terms/privacy`, `/Account/register`, `/Account/passForgot`
- **Área logada do banking**  
  Ex.: `/Banking/Home/index`, `/Banking/Consumer/order`, `/Banking/Subcampaign/index`
- **Painel administrativo (Plataform)**  
  Ex.: `/Plataform/Consumer/index`, `/Plataform/Banner/add`, `/Plataform/Order/exportAll`
- **Backoffice**  
  Ex.: `/Backoffice/Campaigns/index`, `/Backoffice/Transaction/export`, `/Backoffice/Point/pointsExpiring`

---

## Rotas da área não logada do banking

- **Localização:** `module/AppSite`  
- **Acesso:** não precisa de liberação

Exemplos:

### Rota existente: `/Account/register`

- **Controller:** `module/AppSite/src/AppSite/Controller/AccountController.php`  
  - Função: `registerAction`
- **Service:** `module/AppSite/src/AppSite/Service/Proponto/AccountService.php`  
  - Função: `registerAction`
- **View:** `module/AppSite/view/proponto/account/register.phtml`

### Nova rota: `/Account/Terms/newRules`

- **Controller:** `module/AppSite/src/AppSite/Controller/TermsController.php`  
  - Função: `newRulesAction`
- **Service:** `module/AppSite/src/AppSite/Service/Proponto/TermsService.php`  
  - Função: `newRulesAction`
- **View:** `module/AppSite/view/proponto/terms/new-rules.phtml`

---

## Rotas da área logada do banking

- **Localização:** `module/AppBanking`  
- **Acesso:** precisa de liberação

Exemplos:

### Rota existente: `/Banking/Consumer/order`

- **Controller:** `module/AppBanking/src/AppBanking/Controller/ConsumerController.php`  
  - Função: `orderAction`
- **Service:** `module/AppBanking/src/AppBanking/Service/Proponto/ConsumerService.php`  
  - Função: `orderAction`
- **View:** `module/AppBanking/view/app-banking-proponto/consumer/order.phtml`

### Nova rota: `/Banking/Training/ranking`

- **Controller:** `module/AppBanking/src/AppBanking/Controller/TrainingController.php`  
  - Função: `rankingAction`
- **Service:** `module/AppBanking/src/AppBanking/Service/Proponto/TrainingService.php`  
  - Função: `rankingAction`
- **View:** `module/AppBanking/view/app-banking-proponto/training/ranking.phtml`

---

## Rotas do painel administrativo (plataform)

- **Localização:** `module/AppPlataform`  
- **Acesso:** precisa de liberação

Exemplos:

### Rota existente: `/Plataform/Consumer/index`

- **Controller:** `module/AppPlataform/src/AppPlataform/Controller/ConsumerController.php`  
  - Função: `indexAction`
- **Service:** `module/AppPlataform/src/AppPlataform/Service/Proponto/ConsumerService.php`  
  - Função: `indexAction`
- **View:** `module/AppPlataform/view/app-plataform-proponto/consumer/index.phtml`

### Nova rota: `/Plataform/User/blockControl`

- **Controller:** `module/AppPlataform/src/AppPlataform/Controller/UserController.php`  
  - Função: `blockControlAction`
- **Service:** `module/AppPlataform/src/AppPlataform/Service/Proponto/UserService.php`  
  - Função: `blockControlAction`
- **View:** `module/AppPlataform/view/app-plataform-proponto/user/block-control.phtml`

---

## Rotas do backoffice

1. Devem ser criadas dentro da pasta `module/AppBackoffice`.
2. Precisam de liberação de acesso.
3. Por padrão, os controllers do backoffice não possuem service.

Exemplos:

### Rota existente: `/Backoffice/Point/pointsExpiring`

- **Controller:** `module/AppBackoffice/src/AppBackoffice/Controller/PointController.php`  
  - Função: `pointsExpiringAction`
- **View:** `module/AppBackoffice/view/app-backoffice/point/points-expiring.phtml`

### Nova rota: `/Backoffice/Blacklist/info`

- **Controller:** `module/AppBackoffice/src/AppBackoffice/Controller/BlacklistController.php`  
  - Função: `infoAction`
- **View:** `module/AppBackoffice/view/app-backoffice/blacklist/info.phtml`

---

## Liberando/proibindo acesso às rotas

---

## Criando controllers e services 

---

## Rotas personalizadas para campanhas específicas 

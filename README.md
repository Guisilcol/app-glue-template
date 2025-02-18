# App Glue Template

Este repositório é um template projetado para simplificar a criação e configuração de Glue Jobs. Ele já vem pré-configurado, permitindo que você foque exclusivamente no desenvolvimento das funcionalidades, sem se preocupar com configurações complexas de infraestrutura.

## Estrutura do Projeto

A estrutura do projeto foi organizada em três áreas principais:

- **Aplicação (app/):**  
  - **src/libs/**  
    - Contém o pacote Python (`libs`) com os módulos de código (por exemplo, `some_module`).  
    - O arquivo `setup.py` é usado para buildar o pacote em um arquivo wheel.
  - **main.py:**  
    - Importa os módulos do pacote, por exemplo, `libs.some_module`.
  - **dependencies/:**  
    - Após a build, o wheel resultante (por exemplo, `libs-0.1-py3-none-any.whl`) é armazenado aqui.
  - **tests/:**  
    - Possui os testes do projeto.

- **Infraestrutura (infra/):**  
  - Arquivos principais de Terraform para provisionamento da infraestrutura (ex.: `main.tf`, `glue_job.tf`, `variables.tf`).
  - **env/:**  
    - Contém arquivos de variáveis (como `dev.tfvars`, `prd.tfvars`) e configurações de backend do Terraform.
  - **modules/:**  
    - Módulos Terraform reutilizáveis. Em especial, o módulo [`glue_job_pythonshell`](infra/modules/glue_job_pythonshell) é responsável por criar o AWS Glue Job e, agora, inclui também a criação/atualização dos objetos S3 para os arquivos da aplicação (definido no `s3.tf`).

- **CI/CD (cicd/):**  
  - **build.sh:**  
    - Verifica e cria (caso necessário) um ambiente virtual Python.
    - Realiza a limpeza de diretórios `__pycache__`.
    - Instala as dependências necessárias (`wheel` e `build`).
    - Builda o módulo `libs` localizado em `app/src/libs` e armazena o arquivo wheel em `app/dependencies/`.
  - **deploy.sh:**  
    - Valida parâmetros e configura as variáveis de ambiente AWS a partir do perfil configurado.
    - Limpa os diretórios `__pycache__`.
    - Inicializa e aplica as configurações do Terraform (usando o parâmetro `-chdir=infra`) conforme o ambiente desejado (dev ou prd).

## CI/CD - Build e Deploy

### Build

Execute o script de build a partir da raiz do projeto:

```sh
./cicd/build.sh
```

#### Esse script:

- Cria/ativa um ambiente virtual Python, se necessário.
- Remove diretórios __pycache__.
- Instala as dependências necessárias para build.
- Gera o arquivo wheel da aplicação (em libs) e salva-o em dependencies.

### Deploy
Para realizar o deploy da infraestrutura com Terraform, execute:

Onde:
```sh
./cicd/deploy.sh <aws-profile> <env>
```

- \<aws-profile> é o perfil configurado na AWS CLI.
- \<env> é o ambiente desejado (dev ou prd).
O script deploy.sh configura as variáveis AWS, inicializa o Terraform na pasta infra (usando a flag -chdir=infra para não mudar o diretório atual) e aplica as configurações com as variáveis definidas em dev.tfvars ou prd.tfvars.

## Considerações Finais
- Certifique-se de ter o AWS CLI e o Terraform instalados e configurados corretamente.
- Revise os arquivos de variáveis (como variables.tf e infra/env/dev.tfvars) para ajustar as configurações conforme seu ambiente.
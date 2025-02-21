#!/bin/bash
set -euo pipefail

# Validação dos parâmetros de entrada
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <profile> <env>"
    echo "Onde <env> pode ser 'dev' ou 'prd'"
    exit 1
fi

profile="$1"
env="$2"

# Validação do valor do parâmetro <env>
if [ "$env" != "dev" ] && [ "$env" != "prd" ]; then
    echo "Erro: O parâmetro <env> deve ser 'dev' ou 'prd'. Valor informado: '$env'"
    exit 1
fi

# Validação se o perfil informado existe
if ! aws configure list-profiles | grep -q "^${profile}\$"; then
    echo "CICD: Erro: O perfil AWS CLI '$profile' não foi encontrado. Por favor, configure-o antes de executar este script."
    exit 1
fi

# Verifica se o AWS CLI está instalado
if ! aws --version > /dev/null 2>&1; then
    echo "CICD: Erro: AWS CLI não está instalado. Por favor, instale o AWS CLI antes de executar este script."
    exit 1
fi

# Verifica se o Terraform está instalado
if ! command -v terraform > /dev/null 2>&1; then
    echo "CICD: Erro: Terraform não está instalado. Por favor, instale o Terraform antes de executar este script."
    exit 1
fi

# Configura as variáveis de ambiente da AWS
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile "$profile")
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile "$profile")
export AWS_SESSION_TOKEN=$(aws configure get aws_session_token --profile "$profile")
export AWS_DEFAULT_REGION=$(aws configure get region --profile "$profile")

echo "CICD: Variáveis AWS configuradas para o perfil '$profile':"
echo "CICD:   AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
echo "CICD:   AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

echo "CICD: Limpando o repositório: removendo todos os diretórios __pycache__..."
find . -type d -name "__pycache__" -exec rm -rf {} +
echo "CICD: Limpeza concluída."

##############################
# Integração com o Git
##############################

# Garante que as branches 'dev' e 'main' existam; se não existirem, cria-as
if ! git show-ref --verify --quiet refs/heads/dev; then
    echo "CICD: A branch 'dev' não existe. Criando a branch 'dev'..."
    git branch dev
fi

if ! git show-ref --verify --quiet refs/heads/main; then
    echo "CICD: A branch 'main' não existe. Criando a branch 'main'..."
    git branch main
fi

# Obtém o nome da branch atual
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "CICD: Branch atual: $current_branch"

if [ "$env" == "dev" ]; then
    # Para deploy no ambiente dev, a branch atual NÃO deve ser 'dev' nem 'main'
    if [ "$current_branch" == "dev" ] || [ "$current_branch" == "main" ]; then
        echo "CICD: Erro: Para deploy no ambiente dev, a branch atual deve ser diferente de 'dev' ou 'main'."
        exit 1
    fi

    echo "CICD: Realizando merge da branch '$current_branch' na branch 'dev'..."
    git checkout dev
    git merge "$current_branch" --no-ff -m "Merge da branch '$current_branch' para deploy na dev"
    git push origin dev
    
    # Retorna para a branch original (opcional)
    git checkout "$current_branch"

elif [ "$env" == "prd" ]; then
    # Para deploy no ambiente prd (produção/main), a branch atual deve ser 'dev'
    if [ "$current_branch" != "dev" ]; then
        echo "CICD: Erro: Para deploy no ambiente prd (main), a branch atual deve ser 'dev'."
        exit 1
    fi

    echo "CICD: Realizando merge da branch 'dev' na branch 'main'..."
    git checkout main
    git merge dev --no-ff -m "Merge da branch 'dev' para deploy em produção (main)"
    git push origin main
    
    # Retorna para a branch 'dev' (opcional)
    git checkout dev
fi

##############################
# Deploy via Terraform
##############################
echo "CICD: Inicializando e aplicando o Terraform para o ambiente '$env'..."
terraform -chdir=infra init -reconfigure -backend-config="env/${env}.backend.config"
terraform -chdir=infra apply -auto-approve -var-file="env/${env}.tfvars"

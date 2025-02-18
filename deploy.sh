#!/bin/bash

profile="$1"
env="$2"

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile "$profile")
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile "$profile")
export AWS_SESSION_TOKEN=$(aws configure get aws_session_token --profile "$profile")
export AWS_DEFAULT_REGION=$(aws configure get region --profile "$profile")

echo "Variáveis configuradas para o profile '$profile':"
echo "  AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
echo "  AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

# a venv is not active?
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Venv is not active"
    echo "Creating and activating venv"

    python -m venv .venv
    source .venv/bin/activate
    echo "Venv created and activated: $VIRTUAL_ENV"
else
    echo "A venv is already active: $VIRTUAL_ENV"
fi


echo "Installing dependencies to build dependencies"
pip install wheel build

echo "Building dependencies"
python -m build --wheel --outdir ./app/dependencies/ ./app/src/libs

terraform -chdir=infra init -backend-config=env/dev.backend.config
#terraform -chdir=infra plan -var-file=env/dev.tfvars
terraform -chdir=infra apply -auto-approve -var-file=env/dev.tfvars
#!/bin/bash

# Validate input parameters
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <profile> <env>"
    echo "Where <env> can be 'dev' or 'prd'"
    exit 1
fi

profile="$1"
env="$2"

# Validate the value of the env parameter
if [ "$env" != "dev" ] && [ "$env" != "prd" ]; then
    echo "Error: The <env> parameter must be 'dev' or 'prd'. Provided value: '$env'"
    exit 1
fi

# Check if AWS CLI is installed by verifying its version output
if ! aws --version > /dev/null 2>&1; then
    echo "Error: AWS CLI is not installed. Please install AWS CLI before running this script."
    exit 1
fi

# Configure AWS environment variables
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile "$profile")
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile "$profile")
export AWS_SESSION_TOKEN=$(aws configure get aws_session_token --profile "$profile")
export AWS_DEFAULT_REGION=$(aws configure get region --profile "$profile")

echo "AWS variables configured for profile '$profile':"
echo "  AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
echo "  AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"

echo "Cleaning repository: Removing all __pycache__ directories..."
find . -type d -name "__pycache__" -exec rm -rf {} +
echo "Cleanup completed."

echo "Initializing and applying Terraform for environment '$env'..."
terraform -chdir=infra init -backend-config="env/${env}.backend.config"
terraform -chdir=infra apply -auto-approve -var-file="env/${env}.tfvars"

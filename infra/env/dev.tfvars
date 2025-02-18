#########################
# Backend configuration #
#########################

aws_region                  = "us-east-1"
backend_bucket              = "bucket-tfstates-dev"
backend_key                 = "terraform.tfstate"

####################################
# Source code bucket configuration #
####################################

source_code_bucket          = "source-code-bucket-aec41e7c-d019-4ea2-9d9e-29062d0f77c7"
source_code_folder_key      = "app-glue-template/app"
source_code_main_file_key   = "main.py"

##########################
# Glue Job configuration #
##########################

glue_job_name               = "my-dev-glue-job"
glue_role_arn               = "arn:aws:iam::058264288790:role/GeneralPipelineGlueRole"
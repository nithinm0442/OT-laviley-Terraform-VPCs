#!/bin/bash
set -o nounset
set -o errexit


echo "###############################"
echo "## Starting Terraform script ##"
echo "###############################"

ENV="${ENV:-insight-dev}"
AWS_REGION="${AWS_REGION:-us-west-2}"
# ACCOUNT_ID="${ACCOUNT_ID:-569239667213}"
echo "Configuring AWS Profiles"
export AWS_PROFILE=default

# export TF_VAR_access_key=$AWS_ACCESS_KEY_ID_LOCAL
# export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY_LOCAL
# aws configure set role_arn "arn:aws:iam::${ACCOUNT_ID}:role/laivly-deployment-role" --profile ${ENV}-laivly-deployment-profile
# aws configure set source_profile laivly --profile ${ENV}-laivly-deployment-profile
# aws configure set role_session_name laivly-session --profile ${ENV}-laivly-deployment-profile
# export AWS_PROFILE=${ENV}-laivly-deployment-profile

APPLY=${1:-0} #If set terraform will force apply changes
echo "${ENV}"
echo "${AWS_REGION}"

# terraform init \
# -upgrade \
# -backend-config="bucket=state.terraform.laivly.technology.${ENV}" \
# -backend-config="key=${ENV}/laivly-infra.tfstate" \
# -backend-config="region=${AWS_REGION}"

terraform init \
-backend-config="bucket=ot-terraform-state-${ENV}" \
-backend-config="key=${ENV}/opentext-infra.tfstate" \
-backend-config="region=${AWS_REGION}"


terraform validate
terraform plan -var-file=envs/${ENV}.tfvars

if [ $APPLY == 2 ]; then
    echo "###############################"
    echo "## Executing terraform destroy ##"
    echo "###############################"
    terraform destroy --auto-approve -var-file=envs/${ENV}.tfvars
fi

if [ $APPLY == 1 ]; then
    echo "###############################"
    echo "## Executing terraform apply ##"
    echo "###############################"
    terraform apply --auto-approve -var-file=envs/${ENV}.tfvars
fi
#!/bin/bash

TERRAFORM="/usr/local/bin/terraform"
PLAN_FILE="plan.tfplan"


cd terraform/
$TERRAFORM --version
$TERRAFORM init

VARS_FILES=""
for f in ./vars-files/*; do
    VARS_FILES+=" -var-file=$f ";
done;

$TERRAFORM plan \
    -out $PLAN_FILE \
    -detailed-exitcode \
    ${VARS_FILES}

if [ $? = 0 ]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0 # handle exits from shell or function but don't exit interactive shell
fi

read -p "Continue? " -r;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 0 || return 0 # handle exits from shell or function but don't exit interactive shell
fi

echo "Applying"
$TERRAFORM apply $PLAN_FILE

if [ $? != 0 ]; then
    exit 1
fi
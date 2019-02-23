#!/bin/bash
echo "Generating AWS vars"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
AWS_REGION="$(aws configure get region)"

if [ -f ./terraform/vars-files/aws.tfvars ]; then
    rm ./terraform/vars-files/aws.tfvars
fi
touch ./terraform/vars-files/aws.tfvars
echo "aws_account_id = \"$AWS_ACCOUNT_ID\"" >> ./terraform/vars-files/aws.tfvars
echo "aws_region = \"$AWS_REGION\"" >> ./terraform/vars-files/aws.tfvars


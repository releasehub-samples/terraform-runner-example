#!/bin/bash

echo "AWS IDENTITY":
aws sts get-caller-identity

# Just in case parameters are somewhere other than the cluster region, you could modify this: 
export PARAMETER_REGION=$RELEASE_CLUSTER_REGION

# It's important that this match whatever you've decided to use when writing outputs to 
# SSM Parameter Store from your Terraform modules. It should be unique for a given environment: 
export PARAMETER_NAME_PREFIX="/releasehub/$RELEASE_APP_NAME/$RELEASE_BRANCH_NAME/$RELEASE_ENV_ID"

function writeParameterToEnv {
    PARAMETER_KEY=$1
    PARAMETER_NAME="$PARAMETER_NAME_PREFIX/$PARAMETER_KEY"
    echo "Retrieving parameter from AWS Parameter Store in $PARAMETER_REGION: $PARAMETER_NAME"
    if ! PARAMETER_VALUE=$(aws ssm get-parameter --name $PARAMETER_NAME  --region=$PARAMETER_REGION --query "Parameter.Value" --output text); then
        PARAMETER_VALUE="Error: failed to call aws ssm get-parameter --name $PARAMETER_NAME"  
    else
        echo "Retrieved value: $PARAMETER_VALUE"
        echo "REACT_APP_$PARAMETER_KEY=\"$PARAMETER_VALUE\"" >> .env
    fi
}

cat <<EOT > .env
REACT_APP_RELEASE_ACCOUNT_ID="$RELEASE_ACCOUNT_ID"
REACT_APP_RELEASE_APP_NAME="$RELEASE_APP_NAME"
REACT_APP_RELEASE_ENV_ID="$RELEASE_ENV_ID"
REACT_APP_RELEASE_BRANCH_NAME="$RELEASE_BRANCH_NAME"
EOT

writeParameterToEnv "api_base_url"      # Endpoint for our API Gateway backed by Lambda
writeParameterToEnv "fargate_alb_endpoint"      # Load balancer for our ECS Fargate service

npm run build
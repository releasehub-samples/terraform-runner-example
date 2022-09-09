#!/bin/bash

echo "AWS IDENTITY":
aws sts get-caller-identity

# Just in case parameters are somewhere other than the cluster region, you could modify this: 
export PARAMETER_REGION=$RELEASE_CLUSTER_REGION

# Retrieve the DNS endpoint of API Gateway previously created from our Terraform:
PARAMETER_NAME="/releasehub/$RELEASE_APP_NAME/$RELEASE_BRANCH_NAME/$RELEASE_ENV_ID/api_base_url"
echo Attempting to retrieve parameter: $PARAMETER_NAME


if ! REACT_APP_API_BASE_URL=$(aws ssm get-parameter --name $PARAMETER_NAME  --region=$PARAMETER_REGION); then
    echo "Error: failed to call aws ssm get-parameter --name $PARAMETER_NAME"    
else
    echo Retrieved API Base URL: $REACT_APP_API_BASE_URL
    npm run build
fi    
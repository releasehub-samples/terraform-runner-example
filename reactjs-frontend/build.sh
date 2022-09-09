#!/bin/bash

# Retrieve the DNS endpoint of API Gateway previously created from our Terraform:
PARAMETER_NAME="/releasehub/$RELEASE_APP_NAME/$RELEASE_BRANCH_NAME/$RELEASE_ENV_ID/api_base_url"
echo Attempting to retrieve parameter: $PARAMETER_NAME
export REACT_APP_API_BASE_URL=$(aws ssm get-parameter --name $PARAMETER_NAME)

# Was retrieval successful?
if [ ! -z "$REACT_APP_API_BASE_URL" ]   
then    
    export REACT_APP_API_BASE_URL="Error: failed to call aws ssm get-parameter --name $PARAMETER_NAME"    
    echo $REACT_APP_API_BASE_URL
else
    echo Retrieved API Base URL: $REACT_APP_API_BASE_URL
fi    

# Build react app: 
npm run build
#!/bin/bash

PARAMETER_NAME="/releasehub/$RELEASE_APP_NAME/$RELEASE_BRANCH_NAME/$RELEASE_ENV_ID/api_base_url"
export REACT_APP_API_BASE_URL=$(aws ssm get-parameter --name $PARAMETER_NAME)

if [ ! -z "$REACT_APP_API_BASE_URL" ]   
then    
    export REACT_APP_API_BASE_URL="Error: failed to call aws ssm get-parameter --name $PARAMETER_NAME"    
fi    

npm run react-scripts build
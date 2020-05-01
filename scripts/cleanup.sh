#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 <app-label>"
    echo "Example: $0 max-object-detector"
    exit 1
fi

APP_LABEL=$1 

# delete all resources associated with the deployed app
oc delete all -l app=${APP_LABEL}

# delete the image stream
oc delete imagestream ${APP_LABEL}
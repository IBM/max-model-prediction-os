#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 <app-label>"
    echo "Example: $0 max-object-detector"
    exit 1
fi

APP_LABEL=$1 

echo "Removing resources associated with ${APP_LABEL} ..."

# delete all resources associated with the deployed app
oc delete all -l app=${APP_LABEL}

# delete individual resources
#oc delete route ${APP_LABEL}
#oc delete deployment ${APP_LABEL}
#oc delete service ${APP_LABEL}
#oc delete imagestream ${APP_LABEL}

echo "Listing resources associated with ${APP_LABEL} ..."

oc get all | grep ${APP_LABEL}

RETURN_CODE=$?
if [[ $RETURN_CODE -eq 0 ]]
then
    echo "Error. One or more resources were not removed."
    exit 1
fi

echo "All resources associated with ${APP_LABEL} were removed."
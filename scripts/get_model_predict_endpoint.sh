#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 <service-name>"
    exit 1
fi

# Retrieve route information
GET_ROUTE=`oc get route $1 -o JSON`
if [[ $? -ne 0 ]]
then
   echo "Error. Cannot obtain route for ${1}"
   exit 1
fi

# extract host name from response
HOST_NAME=`echo ${GET_ROUTE} | jq '.spec.host' | cut -d'"' -f 2`

# generate /model/predict endpoint URL
ENDPOINT_URL="http://${HOST_NAME}/model/predict"

# display URL
echo $ENDPOINT_URL

#!/bin/sh
###################################################################################
# Register Tekton Triggers in a project using IBM Garage Cloud Native Toolkit
#
# Author : Cong Nguyen
# email  : cong.nguyen@au1.ibm.com
#
###################################################################################
echo "Registring Tekton triggers..."

# Specify APP_NAME and PIPELINE_NAME
APP_NAME=$1
PIPELINE_NAME=$2
GIT_REPO_LINK=$3

if [[ $# -eq 0 ]] ; then
  echo "create-trigger.sh {APP_NAME} {PIPELINE_NAME} {GIT_REPO_LINK}"
  exit
fi

# input validation
if [ -z "${APP_NAME}" ]; then
    echo "Please provide APP_NAME as first parameter"
    exit
fi

# input validation
if [ -z "${PIPELINE_NAME}" ]; then
    echo "Please provide your PIPELINE_NAME as second paramter"
    exit
fi

# input validation
if [ -z "${GIT_REPO_LINK}" ]; then
    echo "Please provide your GIT_REPO_LINK as fourth paramter"
    exit
fi

# Apply the yaml to cluster
cat 01_binding.yaml | sed "s/#APP_NAME/${APP_NAME}/g" | kubectl apply -f -
cat 02_template.yaml | sed "s/#APP_NAME/${APP_NAME}/g" | sed "s@#PIPELINE_NAME@${PIPELINE_NAME}@g"| sed "s@#GIT_REPO_LINK@${GIT_REPO_LINK}@g"| kubectl apply -f -
cat 03_event_listener.yaml | sed "s/#APP_NAME/${APP_NAME}/g" | kubectl apply -f -

echo "Tekton triggers registered."

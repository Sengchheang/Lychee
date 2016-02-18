#!/bin/bash -ex
exit 0

FILE_NAME=$(basename "$0")
STAGE="${FILE_NAME%.*}"
PROJECT_ID="016-702"
SSH_USER="${STAGE}-${PROJECT_ID}"

ansible-playbook config/jenkins/deploy/playbook.yml \
  -vvvv \
  -i config/jenkins/deploy/inventory.yml \
  --extra-vars "version=${GIT_COMMIT}
                stage=${STAGE}
                project_id=${PROJECT_ID}
                ssh_user='${SSH_USER}'
                deploy_id='${DEPLOY_ID}'"

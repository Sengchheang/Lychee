#!/bin/bash -ex

PROJECT_ID="016-702"
WORKSPACE_PATH="../../../workspace"
GIT_REPO="https://github.com/Sengchheang/Lychee.git"
BUILD_PATH="typo3conf/ext/we_sitepackage"
TARGET_PATH="../builds/${BUILD_ID}"

echo "Create directory on Jenkins Server for compile resource"
ansible localhost -m file -a "path={{ playbook_dir }}/${WORKSPACE_PATH} state=directory"

echo "Clone git repository"
ansible localhost -m git -a "repo=${GIT_REPO} dest={{ playbook_dir }}/${WORKSPACE_PATH} version=${GIT_COMMIT} accept_hostkey=yes force=yes"

# echo "Install Grunt modules with npm"
# ansible localhost -m shell -a "npm install chdir={{ playbook_dir }}/${WORKSPACE_PATH}/${BUILD_PATH}"

# echo "Install bower modules"
# ansible localhost -m bower -a "path={{ playbook_dir }}/${WORKSPACE_PATH}/${BUILD_PATH}"

# echo "Compile resource with Grunt"
# ansible localhost -m shell -a "grunt build chdir={{ playbook_dir }}/${WORKSPACE_PATH}/${BUILD_PATH}"

# echo "Copy compile resource to current build folder"
# ansible localhost -m synchronize -a "src={{ playbook_dir }}/${WORKSPACE_PATH}/${BUILD_PATH}/Resources/Public/ dest={{ playbook_dir }}/${TARGET_PATH}/Public/ delete=yes"

How to configure deployment with ansible
========================================

QuickStart
----------

### Initial setup

You have a new project to setup the deployment and assuming that you have configured ssh access between servers,
apply correct server configuration and already clone the project to your local. The only thing you need to do is:

  - Adjust the project ID in `latest.sh`, `demo.sh` and `live.sh` -> That's it!

Commit the changes and let Jenkins build to the stages and wait for result. You should have a working latest and demo TYPO3Box after that.

### Configure `phing` and enable it

  - Login to admin user of the project, set a content master and adjust phing config where necessary.
  - Run one time `phing update-content` command manually to test if your configuration work (watch output of phing)
  - Open `playbook.yml` and change the setting to `phing_enable: "yes"`

### Live site configuration

Read the advanced guide below.

A bit more advanced guide
-------------------------

### 1. Open `inventory.yml` and check if the IP address for `latest`, `demo` and `live` is correct

  - For `latest` and `demo`, it should be already OK for you with `Joel` IP server `10.10.10.27`
  - `ansible_ssh_private_key_file=~/.ssh/id_rsa` should be kept as it is because it is already correct for jenkins user unless you have a special deployment setup
  - Make sure that jenkins user can ssh using key (without password) to all servers you defined using latest user, demo user and live user (see point 4 for how to set username)

### 2. Open `latest.sh`, `demo.sh` and `live.sh`

  - Update the PROJECT_ID variable to your project ID
  - Adjust the environment variables for ansible playbook if needed. In most cases, the default should be OK for `latest` and `demo`. For live, you MUST adjust it according to hosting environment (See point 4)

### 3. Open `playbook.yml` and add/remove task if necessary

  - The default tasks are for deploying TYPO3Box and this should be OK for deploying your project too in most cases but feel free to adjust it to the setup routine of your project
  - If you need to run a task for specific server, use condition `when: stage == 'latest'` or `when: stage != 'live'`

### 4. Overwriting environment variables

  - In `playbook.yml`, you will see the default variables like:

```python
  vars:
    public_html_path: "/home/{{ ssh_user }}/public_html"
    resource_path: "typo3conf/ext/we_sitepackage/Resources/Public"
    php_path: "/opt/php-versions/php55/bin/php"
    composer_path: "/usr/local/bin/composer"
    composer_flags: "--no-dev"
```

  - So in case your php path on the `live` server is different from the default, you need to open the file `live.sh` and add the variable in `--extra-vars` parameter of ansible playbook

```bash
ansible-playbook config/jenkins/deploy/playbook.yml \
  -vvvv \
  -i config/jenkins/deploy/inventory.yml \
  --extra-vars "version=${GIT_COMMIT}
                stage=${STAGE}
                project_id=${PROJECT_ID}
                build_number=${BUILD_NUMBER}
                build_timestamp=${BUILD_ID}
                ssh_user='${STAGE}-${PROJECT_ID}'
                php_path='/usr/bin/php'"
```

  - Or even better make it a variable on top so it's clear and then it would look like:

```bash
#!/bin/bash -ex

FILE_NAME=$(basename "$0")
STAGE="${FILE_NAME%.*}"
PROJECT_ID="015-702"
PHP_PATH="/usr/bin/php"

ansible-playbook config/jenkins/deploy/playbook.yml \
  -vvvv \
  -i config/jenkins/deploy/inventory.yml \
  --extra-vars "version=${GIT_COMMIT}
                stage=${STAGE}
                project_id=${PROJECT_ID}
                build_number=${BUILD_NUMBER}
                build_timestamp=${BUILD_ID}
                ssh_user='${STAGE}-${PROJECT_ID}'
                php_path=${PHP_PATH}"
```

  - One hidden variable that you need to be careful with is the `ssh_user` variable that ansible need to do the ssh login (See point 1).
  For `latest` and `demo`, the username should be working for you by default because the script will take the stage name and project id
  so for example for TYPO3Box it would be `latest-015-702` or `demo-015-702` (the IP address of the server should be defined in `inventory.yml`)
  - Most of the time on live server you won't have the username as `live-015-702` but it will always be different by project. In this case,
  your `live.sh` file should be adjusted and for example if the user is `webessentials`, the playbook `--extra-vars` should be:

```bash
ansible-playbook config/jenkins/deploy/playbook.yml \
  -vvvv \
  -i config/jenkins/deploy/inventory.yml \
  --extra-vars "version=${GIT_COMMIT}
                stage=${STAGE}
                project_id=${PROJECT_ID}
                build_number=${BUILD_NUMBER}
                build_timestamp=${BUILD_ID}
                ssh_user='webessentials'"
```

  - `public_html_path` is another variable that could be different on live server

### 5. Managing website content `phing`

  - For first setup, you are deploying to a blank system/database so phing doesn't make sense at first install so it is disabled by default with
  with the setting `phing_enable: "no"` in `playbook.yml`
  - After the first install, it is required that you need to configure phing to keep the control of the content and then you need to reverse
  defaut setting to have `phing_enable: "yes"` and commit this changes to the repository
  - Enable `phing` is currently only affecting the `latest` server. You need to adjust to condition in `playbook.yml` task to fit your content master setup.

Author
======

  * Visay Keo <visay@web-essentials.asia>
  * Man Math <man@web-essentials.asia>

#!/usr/bin/env bash
set -eEuo pipefail

ACTIONS_RUNNER_INPUT_NAME=$HOSTNAME
export RUNNER_ALLOW_RUNASROOT=1

echo $GH_TOKEN
echo "HOLA ESTA ES MI ORGANIZACION -> " $REPO_OWNER 

/actions-runner/config.sh --url "https://github.com/$REPO_OWNER" --token $GH_TOKEN --labels $NAME
/actions-runner/run.sh
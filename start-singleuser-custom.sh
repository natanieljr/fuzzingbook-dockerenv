#!/bin/bash -
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

USER_HOME=/home/$NB_USER

#
# install/update the fuzzingbook
#
if [[ ! -d "${USER_HOME}/fuzzingbook-code" ]]; then
    wget https://www.fuzzingbook.org/dist/fuzzingbook-code.zip -O "${USER_HOME}/fuzzingbook-code.zip"
    unzip "${USER_HOME}/fuzzingbook-code.zip" -d "${USER_HOME}/fuzzingbook-code"
fi

pip install -e "${USER_HOME}/fuzzingbook-code/fuzzingbook"

#
# setup the projects
#
"${USER_HOME}"/project1/scripts/setup-project.sh

#
# setup permissions
#
echo "signing notebooks"
jupyter trust $(find "${USER_HOME}/work" -name "*.ipynb")

fix-permissions "${USER_HOME}/work"
fix-permissions "${USER_HOME}/.local"
fix-permissions "${USER_HOME}/.local/share/jupyter"

#
# start Jupyter Lab
#
set -e

if [[ "$NOTEBOOK_ARGS $@" != *"--ip="* ]]; then
  NOTEBOOK_ARGS="--ip=0.0.0.0 $NOTEBOOK_ARGS"
fi

if [ ! -z "$JPY_PORT" ]; then
  NOTEBOOK_ARGS="--port=$JPY_PORT $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_USER" ]; then
  NOTEBOOK_ARGS="--user=$JPY_USER $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_COOKIE_NAME" ]; then
  NOTEBOOK_ARGS="--cookie-name=$JPY_COOKIE_NAME $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_BASE_URL" ]; then
  NOTEBOOK_ARGS="--base-url=$JPY_BASE_URL $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_PREFIX" ]; then
  NOTEBOOK_ARGS="--hub-prefix=$JPY_HUB_PREFIX $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_API_URL" ]; then
  NOTEBOOK_ARGS="--hub-api-url=$JPY_HUB_API_URL $NOTEBOOK_ARGS"
fi
if [ ! -z "$JUPYTER_ENABLE_LAB" ]; then
  NOTEBOOK_BIN="jupyter labhub"
else
  NOTEBOOK_BIN=jupyterhub-singleuser
fi

. /usr/local/bin/start.sh $NOTEBOOK_BIN "${USER_HOME}/work" --notebook-dir="${USER_HOME}/work" $NOTEBOOK_ARGS $@


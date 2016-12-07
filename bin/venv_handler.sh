#! /bin/bash

# Copyright (c) 2015 Intracom S.A. Telecom Solutions. All rights reserved.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html

# This script is responsible for activating virtual environment for multinet
# handlers.
# Arguments:
# 01. PYTHONPATH

HANDLER_PATH=$2;

if [ "$HANDLER_PATH" == "/opt/nstat/emulators/nb_generator/run_handler.py" ]; then
# ------------------------------------------------------------------------------
# 02. run_handler.py
# 03. --controller-ip
# 04. --controller-port
# 05. --number-of-flows
# 06. --number-of-workers
# 07. --operation-delay
# 08. --delete-flows
# 09. --restconf-user
# 10. --restconf-password
# 11. --fpr
# 12. --logging-level
# ------------------------------------------------------------------------------
  if [ "$#" -eq 12 ]; then
      source /opt/venv_nb_generator/bin/activate; PYTHONPATH=$1; python3.4 $2 $1 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12}
      exit 0
  else
      echo "Invalid number of arguments."
      exit 1
  fi
elif [ "$HANDLER_PATH" == "/opt/nstat/emulators/nb_generator/bin/handlers/get_oper_ds_flows.py" ]; then
# ------------------------------------------------------------------------------
# 02. get_oper_ds_flows.py
# 03. --controller-ip
# 04. --controller-port
# 05. --restconf-user
# 06. --restconf-password
# ------------------------------------------------------------------------------
  if [ "$#" -eq 6 ]; then
      source /opt/venv_nb_generator/bin/activate; PYTHONPATH=$1; python3.4 $2 $3 $4 $5 $6
      exit 0
  else
      echo "Invalid number of arguments."
      exit 1
  fi
fi
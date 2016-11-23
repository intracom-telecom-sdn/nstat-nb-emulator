#! /bin/bash

# Copyright (c) 2015 Intracom S.A. Telecom Solutions. All rights reserved.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html

# This script is responsible for activating virtual environment for multinet
# handlers.
# Arguments:
# 1. PYTHONPATH
# 2. Handler path

if [ "$#" -eq 3 ]
then
    source /opt/venv_nb_generator/bin/activate; PYTHONPATH=$1 python3.4 $2
else
    echo "Invalid number of arguments."
    exit 1
fi
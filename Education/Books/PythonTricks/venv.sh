#!/bin/bash

#python3 -m venv <folder>
python3 -m venv venv
cd venv
source ./bin/activate # activates venv
which pip3
pip list # list packages
pip install flask
deactivate #turns off venv
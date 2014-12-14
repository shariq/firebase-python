#!/bin/bash

# install the basics on Debian based systems
apt-get install build-essential python python-dev curl

# install pip
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
rm get-pip.py

# install the Python modules listed in requirements.txt
pip install -r requirements.txt

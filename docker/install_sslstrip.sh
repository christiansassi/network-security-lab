#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo. Exiting."
    exit 1
fi

git clone https://github.com/L1ghtn1ng/sslstrip.git
cd sslstrip

if [ -f README.md ]; then
    mv README.md README
fi

pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    pip3 install --break-system-packages -r requirements.txt
fi

python3 setup.py build
python3 setup.py install

cd ..
rm -r sslstrip

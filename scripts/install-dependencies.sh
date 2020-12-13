#!/bin/bash

if [[ ! -z $YUM_CMD ]]; then
    sudo dnf install -y pv
elif [[ ! -z $APT_GET_CMD ]]; then
    sudo apt install -y pv
fi


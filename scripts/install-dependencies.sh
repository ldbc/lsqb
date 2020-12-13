#!/bin/bash

if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y pv
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y pv
fi

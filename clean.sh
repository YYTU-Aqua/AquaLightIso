#!/usr/bin/env bash

script_path="$(readlink -f ${0%/*})"

cd "${script_path}"
sudo make clean
sudo rm -f "${script_path}/system/mkalteriso"

cd - > /dev/null

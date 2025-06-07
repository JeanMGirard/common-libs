#! /usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
INSTALL_DIR="$1"
if [[ -z "$INSTALL_DIR" ]]; then INSTALL_DIR="/usr/local/bin"; fi


sudo ln -sf "$SCRIPT_DIR/bin/snippets.sh" "$INSTALL_DIR/snippets"
sudo chmod 777 "$SCRIPT_DIR/bin/snippets.sh" "$INSTALL_DIR/snippets"


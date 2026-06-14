#!/bin/bash

# all extension ids
EXTENSIONS=(
    "EditorConfig.EditorConfig"
    "mrmlnc.vscode-duplicate"
)

echo "Starting Codium extension installations"

# install extension one by one
for ext in "${EXTENSIONS[@]}"; do
    echo "Installing: $ext"
    codium --install-extension "$ext"
done

echo "All extensions successfully installed."

#!/bin/bash

# Array mit allen gewünschten VSCodium-Erweiterungen
EXTENSIONS=(
    "EditorConfig.EditorConfig"
    "mrmlnc.vscode-duplicate"
    "golang.Go"
)

echo "Starte Installation der VSCodium-Erweiterungen..."

# Schleife installiert jede Erweiterung einzeln
for ext in "${EXTENSIONS[@]}"; do
    echo "Installiere: $ext"
    codium --install-extension "$ext"
done

echo "Alle Erweiterungen erfolgreich installiert!"

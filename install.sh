#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "🛠️ Starte Dotfiles-Installation..."

# Hilfsfunktion für sichere Symlinks (mit Backup-Logik)
create_symlink() {
    local source_file="$1"
    local target_file="$2"

    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        if [ "$(readlink "$target_file")" == "$source_file" ]; then
            return # Bereits korrekt verknüpft
        fi
        mkdir -p "$BACKUP_DIR"
        mv "$target_file" "$BACKUP_DIR/"
        echo "✅ Backup erstellt: $target_file -> $BACKUP_DIR/"
    fi

    # Übergeordneten Ordner im Ziel erstellen, falls nötig
    mkdir -p "$(dirname "$target_file")"
    ln -s "$source_file" "$target_file"
    echo "✅ Verknüpft: $target_file"
}

# --- LOCAL GITCONFIG GENERIEREN ---
LOCAL_GIT="$HOME/.gitconfig.local"
if [ ! -f "$LOCAL_GIT" ]; then
    echo "🛠️ Keine Git-Identität (~/.gitconfig.local) gefunden."
    read -p "Gib deinen vollständigen Namen für Git ein: " git_name
    read -p "Gib deine E-Mail-Adresse für Git ein: " git_email

    cat << EOF > "$LOCAL_GIT"
[user]
    name = $git_name
    email = $git_email
EOF
    echo "✅ ~/.gitconfig.local erfolgreich mit deinen Daten erstellt."
fi


# --- 1. ALLGEMEINE DOTFILES VERLINKEN ---
echo "🛠️ Erstelle Symlinks für Konfigurationsdateien..."

create_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/clang-format" "$HOME/.clang-format"


# --- 2. BASH CONFIGS (~/.bashrc.d/) ---
echo "🛠️ Konfiguriere Bash (.bashrc.d)..."

mkdir -p "$HOME/.bashrc.d"

# Schleife über alle Dateien im Repo-Ordner 'bash'
if [ -d "$DOTFILES_DIR/bash" ]; then
    for file_path in "$DOTFILES_DIR/bash"/*; do
        if [ -f "$file_path" ]; then
            filename=$(basename "$file_path")
            create_symlink "$file_path" "$HOME/.bashrc.d/$filename"
        fi
    done
fi

# Intelligente Prüfung: Lädt die .bashrc bereits den Ordner .bashrc.d?
# Wir prüfen, ob ".bashrc.d" im Text vorkommt UND danach eine Schleife/ein Source-Befehl folgt.
ALREADY_INTEGRATED=false
if [ -f "$HOME/.bashrc" ]; then
    # Sucht nach aktiven (nicht auskommentierten) Zeilen, die .bashrc.d einbinden
    if grep -E "^[^#]*\.bashrc\.d" "$HOME/.bashrc" | grep -E -q "source|\. |for "; then
        ALREADY_INTEGRATED=true
    fi
fi

if [ "$ALREADY_INTEGRATED" = true ]; then
    echo "✅ System liest ~/.bashrc.d bereits automatisch ein. Kein Eintrag hinzugefügt."
else
    BASHRC_HOOK='
# Lade alle Config-Dateien aus ~/.bashrc.d
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            source "$rc"
        fi
    done
fi'

    if [ -f "$HOME/.bashrc" ]; then
        echo "$BASHRC_HOOK" >> "$HOME/.bashrc"
        echo "✅ Einlese-Logik für ~/.bashrc.d wurde an deine ~/.bashrc angehängt."
    else
        echo "$BASHRC_HOOK" > "$HOME/.bashrc"
        echo "✅ Neue ~/.bashrc mit der Einlese-Logik für ~/.bashrc.d erstellt."
    fi
fi


# --- 3. VIM KONFIGURATION & PLUGINS ---
echo "🛠️ Konfiguriere Vim ..."

create_symlink "$DOTFILES_DIR/vimrc" "$HOME/.vim/vimrc"
echo "✅ vimrc kopiert, lade vim-plug herunter..."

if curl -fsSL --create-dirs -o "$HOME/.vim/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"; then
    echo "✅ vim-plug wurde erfolgreich heruntergeladen, installiere Plugins..."
    vim -E -s -u "$HOME/.vim/vimrc" +PlugInstall +qall

else
    echo "❌ vim-plug konnte nicht heruntergeladen werden." >&2
fi

# --- 3.5 NEOVIM KONFIGURATION & PLUGINS ---
# echo "🛠️ Konfiguriere NeoVim ..."

# create_symlink "$DOTFILES_DIR/init.lua" "$HOME/.config/nvim/init.lua"
# echo "✅ NeoVim konfiguriert"

# --- 4. VSCODIUM KONFIGURATION & EXTENSIONS ---
echo "🛠️ Konfiguriere VSCodium..."

# JSON-Configs in das VSCodium-Verzeichnis verlinken
create_symlink "$DOTFILES_DIR/codium/settings.json" "$HOME/.config/VSCodium/User/settings.json"
create_symlink "$DOTFILES_DIR/codium/keybindings.json" "$HOME/.config/VSCodium/User/keybindings.json"

# --- INTELIGENTE CLI-ERKENNUNG (NATIV VS. FLATPAK) ---
CODIUM_AVAILABLE=false

if command -v codium &> /dev/null; then
    # Variante A: Nativ installiertes VSCodium gefunden
    CODIUM_AVAILABLE=true
elif command -v flatpak &> /dev/null && flatpak list --columns=application | grep -q "com.vscodium.codium"; then
    # Variante B: Flatpak gefunden -> Wir deklarieren eine Funktion im Speicher des Skripts!
    echo "🛠️ Flatpak-Version von VSCodium erkannt. Erstelle temporären CLI-Wrapper..."
    codium() {
        flatpak run com.vscodium.codium "$@"
    }
    # Funktion exportieren, damit das aufgerufene Erweiterungsskript sie erbt
    export -f codium
    CODIUM_AVAILABLE=true
fi

# Erweiterungsskript starten, sofern VSCodium über einen der beiden Wege erreichbar ist
if [ "$CODIUM_AVAILABLE" = true ]; then
    if [ -f "$DOTFILES_DIR/codium/install-codium-extensions.sh" ]; then
        echo "🛠️ Rufe Codium-Erweiterungsskript auf..."
        chmod +x "$DOTFILES_DIR/codium/install-codium-extensions.sh"
        
        # WICHTIG: Wir führen das Skript mit 'source' (.) aus oder nutzen die exportierte Funktion
        "$DOTFILES_DIR/codium/install-codium-extensions.sh"
    fi
    echo "✅ Fertig! Alle Symlinks gesetzt und Plugins installiert."
else
    echo "❌  VSCodium konnte weder als native CLI noch als Flatpak gefunden werden. Erweiterungen übersprungen."
fi

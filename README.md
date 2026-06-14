# My dotfiles

## Installation

Clone, copy `install.sh.template`, edit the file and execute:

```bash
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/moerkib/dotfiles
cd dotfiles
cp install.sh.template install.sh
chmod +x install.sh
```

This belongs to .bashrc (or equivalent) if not existent:

```bash
# Load all config files from ~/.bashrc.d
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            source "$rc"
        fi
    done
fi
```

#!/bin/bash
# TODO: Add    installation steps for lsps

pacman -S nodejs npm --noconfirm --needed

# pacman -S marksman --noconfirm --needed #markdown

pacman -S markdown-oxide --noconfirm --needed #PKM MD

# npm i -g @mdx-js/language-server

npm i -g bash-language-server

npm i -g vscode-langservers-extracted

npm install -g typescript typescript-language-server

npm install -g @prisma/language-server

npm install -g prettier-plugin-sh

npm install -g prettier-plugin-svelte

pacman -S python --noconfirm --needed

# pacman -S python-lsp-server --noconfirm --needed

npm i -g svelte-language-server

npm i -g typescript-svelte-plugin

npm i -g @tailwindcss/language-server

pacman -S rust --noconfirm --needed

pacman -S rust-analyzer --noconfirm --needed

cargo install taplo-cli --locked --features lsp

npm i -g yaml-language-server@next

npm install -g fish-lsp

# pacman -S harper --noconfirm --needed #spellcheck

pacman -S ruff --noconfirm --needed # python formatter

npm i -g prettier

# npm install -g basedpyright

pacman -S jedi-language-server

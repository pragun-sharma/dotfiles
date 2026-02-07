#!/bin/bash

DOTFILES="$HOME/.config/dotfiles"
echo $DOTFILES
ln -sf "$DOTFILES/.zshrc" "$HOME/.config/zsh/.zshrc"
ln -sf "$DOTFILES/.zsh_plugins.txt" "$HOME/.config/zsh/.zsh_plugins.txt"
ln -sf "$DOTFILES/.zshenv" "$HOME/.zshenv"
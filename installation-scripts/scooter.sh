#!/bin/bash
# TODO: Add installation steps for tmux

pacman -S rust --noconfirm --needed

pacman -S rust-analyzer --noconfirm --needed

cargo install scooter

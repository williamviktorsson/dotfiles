#!/bin/bash
# TODO: Add installation steps for fish

pacman -S fish --noconfirm --needed
chsh -s "$(command -v fish)"

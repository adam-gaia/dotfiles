#!/usr/bin/env bash
# Linux-specific bash configuration

# Rust cargo path for work
export PATH="$HOME/.cargo/bin:${PATH}"

export PATH="/usr/share/source-highlight:${PATH}"

# --------------------------------------------------------------------------------
# Configure Homebrew
# --------------------------------------------------------------------------------
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)



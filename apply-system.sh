#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake .# --show-trace
popd

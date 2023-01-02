#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/alice/home.nix
popd


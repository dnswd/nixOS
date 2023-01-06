#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.alice.activationPackage
./result/activate
popd


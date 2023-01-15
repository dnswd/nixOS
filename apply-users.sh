#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.halcyon.activationPackage
./result/activate
popd


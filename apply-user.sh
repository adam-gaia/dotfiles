#!/bin/sh
set -e
nix build .#homeManagerConfigurations.agaia.activationPackage
./result/activate


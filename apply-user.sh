#!/bin/sh
nix build .#homeManagerConfigurations.agaia.activationPackage
./result/activate


#!/usr/bin/env bash

#install flux & fluxctl
curl -s https://fluxcd.io/install.sh | sudo bash

#configure flux command completions
flux completion zsh > _flux
mv _flux ~/.oh-my-zsh/completions

# flux check --pre

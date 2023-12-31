#!/usr/bin/env bash

build_remot=false

hosts="$1"
shift

if [ -z "$hosts" ]; then
    echo "No hosts to deploy"
    exit 2
fi

for host in ${hosts//,/ }; do
    nixos-rebuild --flake .\#$host switch --target-host $host --use-remote-sudo --use-substitutes $@
done

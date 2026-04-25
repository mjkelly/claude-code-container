#!/bin/bash

vols=(
  opencode-local-share
  opencode-local-state
  opencode-config
  opencode-cache
)
for vol in "${vols[@]}"; do
  if docker volume exists "${vol}"; then
    docker volume rm "${vol}"
  fi
done

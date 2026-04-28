#!/bin/bash

vols=(
  dot-claude-vol
)
for vol in "${vols[@]}"; do
  if docker volume exists "${vol}"; then
    docker volume rm "${vol}"
  fi
done

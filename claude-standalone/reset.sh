#!/bin/bash

vol=dot-claude-vol
if docker volume exists "${vol}"; then
  docker volume rm "${vol}"
fi

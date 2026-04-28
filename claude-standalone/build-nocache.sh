#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"
"${script_dir}/build.sh" --no-cache

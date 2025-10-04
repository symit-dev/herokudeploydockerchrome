#!/bin/bash

rm -rf temp_repo
git clone $GIT_URL temp_repo

# Use cp instead of mv to avoid "Device or resource busy" errors
cp -r temp_repo/. .
rm -rf temp_repo

# Ensure run.sh has execution permissions
chmod +x run.sh

# Execute run.sh
./run.sh

#!/bin/bash

echo -e "\033[0;32mStart to deploy!\033[0m"
time=$(date "+%Y%m%d-%H%M%S")

# Build the hugo project
hugo

# Add all
git add .
# Commit
git commit -m "$time"
# Push
git push -u origin main

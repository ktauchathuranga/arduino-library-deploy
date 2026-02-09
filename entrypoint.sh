#!/bin/bash
# Entrypoint script for the GitHub Action

set -e

# Ensure GITHUB_TOKEN is passed as an argument
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set!"
  exit 1
fi

# Add the repository to Git's safe directory list
git config --global --add safe.directory /github/workspace

# Extract PR details from the event payload
PR_NUMBER=$(jq --raw-output .pull_request.number $GITHUB_EVENT_PATH)
PR_TITLE=$(jq --raw-output .pull_request.title $GITHUB_EVENT_PATH)
PR_VERSION=$(grep '^version=' library.properties | cut -d'=' -f2)

# Extract main version without checking out the branch (avoiding workspace modification)
git fetch origin main --quiet
MAIN_VERSION=$(git show origin/main:library.properties | grep '^version=' | cut -d'=' -f2)

echo "PR Version: $PR_VERSION"
echo "Main Version: $MAIN_VERSION"

# Export variables for Python script
export GITHUB_TOKEN=$GITHUB_TOKEN
export PR_NUMBER
export PR_TITLE
export pr_version=$PR_VERSION
export main_version=$MAIN_VERSION
export GITHUB_REPOSITORY=$GITHUB_REPOSITORY

# Run the Python script
python3 /action/action.py

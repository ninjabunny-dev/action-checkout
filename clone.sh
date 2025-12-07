#!/bin/bash

set -e

URL="$1"
DIR="$2"
TOKEN="$3"
BRANCH="$4"

if [[ -z "$URL" ]]; then
  echo "Error: url parameter is required"
  exit 1
fi

if [[ -z "$DIR" ]]; then
  DIR="."
fi

CLONE_CMD="git clone"

if [[ -n "$BRANCH" ]]; then
  CLONE_CMD="$CLONE_CMD --branch $BRANCH"
fi

if [[ -n "$TOKEN" ]]; then
  CLONE_CMD="$CLONE_CMD https://${TOKEN}@${URL}"
else
  CLONE_CMD="$CLONE_CMD $URL"
fi

CLONE_CMD="$CLONE_CMD $DIR"

echo "Cloning repository..."
echo "Command: $CLONE_CMD"

eval $CLONE_CMD

echo "Repository cloned successfully to: $DIR"
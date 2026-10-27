#!/usr/bin/env bash
# Pins econet-hpwh-esp32-poe.yaml to the latest esphome-econet release tag
# (both the package ref and the project version label), then runs esphome.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAML_FILE="${1:-$REPO_DIR/econet-hpwh-esp32-poe.yaml}"
shift $(( $# > 0 ? 1 : 0 )) || true

echo "Checking latest esphome-econet release..."
LATEST_TAG=$(curl -sf https://api.github.com/repos/esphome-econet/esphome-econet/releases/latest \
  | grep -o '"tag_name": *"[^"]*"' | sed -E 's/.*"([^"]+)"$/\1/')

if [ -z "$LATEST_TAG" ]; then
  echo "No published release found, falling back to latest tag..."
  LATEST_TAG=$(curl -sf https://api.github.com/repos/esphome-econet/esphome-econet/tags \
    | grep -o '"name": *"[^"]*"' | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
fi

if [ -z "$LATEST_TAG" ]; then
  echo "ERROR: could not determine latest tag from GitHub API." >&2
  exit 1
fi

CURRENT_REF=$(sed -En 's/^    ref: (.*)$/\1/p' "$YAML_FILE")
CURRENT_VERSION=$(sed -En 's/^    version: (.*)$/\1/p' "$YAML_FILE")

echo "Latest upstream tag: $LATEST_TAG"
echo "Current ref/version in $YAML_FILE: $CURRENT_REF / $CURRENT_VERSION"

if [ "$CURRENT_REF" != "$LATEST_TAG" ] || [ "$CURRENT_VERSION" != "$LATEST_TAG" ]; then
  sed -E -i '' "s/^    ref: .*/    ref: ${LATEST_TAG}/" "$YAML_FILE"
  sed -E -i '' "s/^    version: .*/    version: ${LATEST_TAG}/" "$YAML_FILE"
  echo "Updated $YAML_FILE to ${LATEST_TAG}"
else
  echo "Already up to date."
fi

exec esphome run "$YAML_FILE" "$@"

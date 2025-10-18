#!/usr/bin/env bash
set -e

# Find the highest existing number
highest=$(ls -d [0-9][0-9][0-9]-* 2>/dev/null | sed 's/-.*//' | sort -n | tail -1)
next=$(printf "%03d" $((10#${highest:-0} + 1)))

# Create directory with provided name
name="$*"
if [ -z "$name" ]; then
	echo "Error: Please provide an experiment name"
	echo "Usage: mise run new <name>"
	exit 1
fi

dirname="${next}-$(echo $name | tr ' ' '-')"
mkdir -p "$dirname"

# Get current date in YYYY-MM-DD format
date=$(date +%Y-%m-%d)

# Copy template and replace placeholders
sed -e "s/{{TITLE}}/${name}/g" -e "s/{{DATE}}/${date}/g" scripts/template.html >"${dirname}/index.html"

echo "✓ Created ${dirname}/"
echo "  Opening in editor..."

# Regenerate index
./scripts/generate-index.sh

# Open the new file (adjust for your editor)
${EDITOR:-nvim} "${dirname}/index.html"

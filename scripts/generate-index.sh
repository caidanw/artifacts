#!/usr/bin/env bash
set -e

cat >index.html <<HEADER
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>artifacts/</title>
  <link rel="preconnect" href="https://cdn.jsdelivr.net" />
  <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/gh/internet-development/www-server-mono@latest/server-mono.css"
  />
  <link rel="stylesheet" href="reset.css" />
  <link rel="stylesheet" href="global.css" />
  <link rel="stylesheet" href="index.css" />
</head>
<body>
  <hgroup>
    <h1>artifacts/</h1>
    <p>experimental web constructs</p>
  </hgroup>
 
  <nav class="artifacts">
HEADER

# Find all experiment directories (format: 001-name)
for dir in [0-9][0-9][0-9]-*/; do
  [ -d "$dir" ] || continue
  [ -f "${dir}index.html" ] || continue

  # Extract number and dirname
  dirname=$(basename "$dir")
  number=$(echo "$dirname" | cut -d'-' -f1)

  # Extract name from title
  name=$(htmlq --text --filename "${dir}index.html" 'title')

  # Try to extract date from meta tag
  date=$(htmlq --attribute content --filename "${dir}index.html" 'meta[name="created"]')

  # Format date from YYYY-MM-DD to YYYY.MM.DD
  if [ -n "$date" ]; then
    display_date=$(echo "$date" | tr '-' '.')
  fi

  cat >>index.html <<ENTRY
    <a href="${dirname}/" class="artifact">
      <span  class="number">${number}</span >
      <div class="info">
        <span  class="name">${name}</span >
        <time class="date" datetime="${date}">${display_date}</time>
      </div>
    </a>

ENTRY
done

cat >>index.html <<'INDEXEOF'
  </nav>
</body>
</html>
INDEXEOF

count=$(ls -d [0-9][0-9][0-9]-*/ 2>/dev/null | wc -l)
echo "✓ Generated index.html with ${count} experiments"

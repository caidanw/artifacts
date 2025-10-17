#!/usr/bin/env bash
set -e

cat >index.html <<HEADER
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>artifacts/</title>
  <link rel="stylesheet" href="reset.css">
  <link rel="stylesheet" href="index.css">
</head>
<body>
  <div class="header">
    <h1>artifacts/</h1>
    <div class="meta">experimental web constructs</div>
  </div>
 
  <div class="artifacts">
HEADER

# Find all experiment directories (format: 001-name)
for dir in [0-9][0-9][0-9]-*/; do
  [ -d "$dir" ] || continue
  [ -f "${dir}index.html" ] || continue

  dirname=$(basename "$dir")

  # Extract number and name from title
  title=$(htmlq --text --filename "${dir}index.html" 'title')
  number=$(echo "$title" | cut -d'-' -f1)
  name=$(echo "$title" | cut -d'-' -f2- | tr '-' ' ')

  # Try to extract date from meta tag
  date=$(htmlq --attribute content --filename "${dir}index.html" 'meta[name="date"]')

  # Format date from YYYY-MM-DD to YYYY.MM.DD
  if [ -n "$date" ]; then
    display_date=$(echo "$date" | tr '-' '.')
  fi

  cat >>index.html <<ENTRY
    <a href="${dirname}/" class="artifact">
      <div class="number">${number}</div>
      <div class="info">
        <div class="name">${name}</div>
        <time class="date" datetime="${date}">${display_date}</time>
      </div>
    </a>

ENTRY
done

cat >>index.html <<'INDEXEOF'
  </div>
</body>
</html>
INDEXEOF

count=$(ls -d [0-9][0-9][0-9]-*/ 2>/dev/null | wc -l)
echo "✓ Generated index.html with ${count} experiments"

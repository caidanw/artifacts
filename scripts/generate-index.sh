#!/usr/bin/env bash
set -e

cat > index.html << 'INDEXEOF'
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
 
  <div class="experiments">
INDEXEOF

# Find all experiment directories (format: 001-name)
for dir in [0-9][0-9][0-9]-*/; do
  [ -d "$dir" ] || continue
  [ -f "${dir}index.html" ] || continue
  
  # Extract number and name from directory
  dirname=$(basename "$dir")
  number=$(echo "$dirname" | cut -d'-' -f1)
  name=$(echo "$dirname" | cut -d'-' -f2- | tr '-' ' ')
  
  # Try to extract title from HTML
  title=$(grep -oP '(?<=<title>).*(?=</title>)' "${dir}index.html" 2>/dev/null || echo "$name")
  
  # Try to extract date from meta tag
  date=$(grep -oP '(?<=<meta name="created" content=").*(?=">)' "${dir}index.html" 2>/dev/null || echo "")
  
  # Format date from YYYY-MM-DD to YYYY.MM.DD
  if [ -n "$date" ]; then
    date=$(echo "$date" | tr '-' '.')
  fi
  
  cat >> index.html << ENTRY
    <a href="${dirname}/" class="experiment">
      <div class="number">${number}</div>
      <div class="info">
        <div class="title">${title}</div>
        <div class="date">${date}</div>
      </div>
    </a>
    
ENTRY
done

cat >> index.html << 'INDEXEOF'
  </div>
</body>
</html>
INDEXEOF

count=$(ls -d [0-9][0-9][0-9]-*/ 2>/dev/null | wc -l)
echo "✓ Generated index.html with ${count} experiments"

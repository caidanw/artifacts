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
  <style>
    @font-face {
      font-family: 'ServerMono';
      src: url('https://cdn.jsdelivr.net/gh/internet-development/www-server-mono@latest/public/fonts/ServerMono-Regular.woff2') format('woff2');
      font-weight: normal;
      font-style: normal;
      font-display: swap;
    }
    

    
    body {
      background: #000;
      color: #fff;
      font-family: 'ServerMono', monospace;
      padding: 40px 20px;
      line-height: 1.4;
    }
    
    .header {
      margin-bottom: 60px;
      border-bottom: 1px solid #333;
      padding-bottom: 20px;
    }
    
    .header h1 {
      font-size: 24px;
      font-weight: normal;
      letter-spacing: -0.5px;
    }
    
    .header .meta {
      font-size: 12px;
      color: #666;
      margin-top: 8px;
    }
    
    .experiments {
      display: grid;
      gap: 2px;
      max-width: 1200px;
    }
    
    .experiment {
      display: grid;
      grid-template-columns: 80px 1fr;
      gap: 20px;
      padding: 20px 0;
      border-bottom: 1px solid #111;
      text-decoration: none;
      color: inherit;
      transition: background 0.15s ease;
      align-items: start;
    }
    
    .experiment:hover {
      background: #0a0a0a;
    }
    
    .experiment:hover .number {
      color: #fff;
    }
    
    .number {
      font-size: 32px;
      color: #333;
      transition: color 0.15s ease;
      text-align: right;
    }
    
    .info {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    
    .title {
      font-size: 14px;
    }
    
    .date {
      font-size: 11px;
      color: #666;
    }
    
    @media (max-width: 768px) {
      .experiment {
        grid-template-columns: 60px 1fr;
        gap: 15px;
      }
      
      .number {
        font-size: 24px;
      }
    }
  </style>
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

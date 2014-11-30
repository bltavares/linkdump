#!/usr/bin/env bash

file=${1:-archive/index.html}

entries() {
    for src in archive/*.org; do
        file="${src%.org}.html"
        title="$(grep 'Title' "$src" | cut -d: -f2)"

        cat <<EOF
<li><a href="$(basename "$file")">${title}</a></li>
EOF
    done
}

cat > $file <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Link Dump - Archive</title>
    <link rel="alternate" type="application/atom+xml" title="Link Dump" href="/atom.xml" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
  </head>
  <body>
    <h1>Link Dump - Archive</h1>
    <a href="../index.html">Up</a>
    <ol>
    $(entries)
    </ol>
  </body>
</html>
EOF

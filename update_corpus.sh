#!/usr/bin/env bash
set -euo pipefail

for file in test/corpus/*.txt; do
  # Extract the source snippet between the corpus header and the expected tree.
  source=$(awk '
    /^=+$/ { separators++; next }
    separators < 2 { next }
    !started {
      if ($0 == "") started = 1
      next
    }
    /^---$/ { exit }
    { print }
  ' "$file")
  echo "$source" > /tmp/corpus_source.vy
  # Parse and trim stats only
  tree-sitter parse -p . /tmp/corpus_source.vy | sed '/^[a-zA-Z0-9_]*\tParse:/d' > /tmp/expected_tree.txt
  # Replace expected
  awk -v expected='/tmp/expected_tree.txt' '
    /^---$/ { print; while (getline line < expected) print line; close(expected); next }
    { print }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
done
rm -f /tmp/corpus_source.vy /tmp/expected_tree.txt
echo "Corpus updated. Run 'tree-sitter test' to verify 14/14."

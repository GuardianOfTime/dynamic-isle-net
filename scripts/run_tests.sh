#!/usr/bin/env bash
# Build and run all test cases (Linux/macOS)
set -e
cd "$(dirname "$0")/.."

echo "Building solver..."
g++ -std=c++17 -O2 -o solver src/main.cpp

failed=0
for input in testcases/input*.txt; do
  [ -f "$input" ] || continue
  base=$(basename "$input" .txt | sed 's/^input//')
  output="testcases/output${base}.txt"
  [ -f "$output" ] || continue
  name=$(basename "$input")
  printf "Testing %s ... " "$name"
  got=$(./solver < "$input")
  want=$(cat "$output")
  if [ "$got" = "$want" ]; then
    echo "OK"
  else
    echo "FAIL"
    ((failed++)) || true
  fi
done

if [ "$failed" -eq 0 ]; then
  echo "All tests passed."
else
  echo "$failed test(s) failed."
  exit 1
fi

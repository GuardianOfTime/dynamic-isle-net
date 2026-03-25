#!/usr/bin/env bash
# Build DynamicIsleNet solver (Linux/macOS)
set -e
cd "$(dirname "$0")/.."
g++ -std=c++17 -O2 -o solver src/main.cpp
echo "Build succeeded: ./solver"

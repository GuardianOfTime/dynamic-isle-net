# DynamicIsleNet

A unique algorithmic project that simulates a **dynamic archipelago of islands**. The challenge combines graph theory, minimum spanning trees (MST), dynamic updates, and grid-based algorithms.

## Quick start

```bash
# Build
make          # or: g++ -std=c++17 -O2 -o solver src/main.cpp

# Run one test
./solver < testcases/input1.txt

# Run all tests (Linux/macOS)
make test     # or: ./scripts/run_tests.sh
```

**Windows:** use **Command Prompt** (`scripts\build.bat`, `scripts\run_tests.bat`) or **PowerShell** (`.\scripts\run_tests.ps1`). You need `g++` in PATH (e.g. MinGW, MSYS2, or WSL).

## Table of contents

- [Overview](#overview)
- [Problem](#problem)
- [Algorithm & Data Structures](#algorithm--data-structures)
- [Project Structure](#project-structure)
- [Build & Run](#build--run)
- [Input Format](#input-format) / [Output Format](#output-format)
- [Performance](#performance)
- [Extensions](#extensions)

## Overview

- **Educational**: Demonstrates how MSTs and Union-Find (DSU) work in a dynamic environment.
- **Challenging**: Combines graphs, combinatorics, and dynamic connectivity.
- **GitHub-friendly**: Structured for testing, sharing, and community contributions.

The goal is to maintain **minimum-cost connectivity** between islands as islands rise or sink in a 2D grid, outputting the MST cost after each change.

## Problem

### Grid

- Grid of size **N × N**.
- `1` = island, `0` = water.
- Each cell has a **stability** value (used as bridge cost weight).

### Bridges

- By default, bridges connect only **orthogonally adjacent** islands (up, down, left, right). Optionally, diagonal neighbors can be enabled in the code (see Extensions).
- Cost of a bridge between islands `(i1,j1)` and `(i2,j2)`:
  - **cost = max(stability[i1][j1], stability[i2][j2])**

### Updates

- Over **Q** days, cells flip: island → water (`1 → 0`) or water → island (`0 → 1`).
- After each update, recompute the **minimum total bridge cost** to connect all current islands.

### Objective

- Connect all islands with bridges so that the **sum of bridge costs is minimized** (MST).
- Output the MST cost after the initial grid and after each update.
- If the islands cannot all be connected (disconnected components), output **-1**.

## Algorithm & Data Structures

### 1. Minimum Spanning Tree (MST)

- **Kruskal's algorithm**: sort edges by cost, add in order while avoiding cycles.
- Fits well with Union-Find for cycle detection.

### 2. Union-Find (Disjoint Set Union – DSU)

- **find(x)**: representative of the set (with path compression).
- **unite(a, b)**: merge two sets (with union by rank).
- Used to track connected components and avoid cycles in the MST.

### 3. Edge generation

- Only edges between **adjacent** island cells (4 directions by default; optional 8 with diagonals — see Extensions).
- Cost for edge between `u` and `v`: **max(stability[u], stability[v])**.
- Edges are regenerated whenever the grid changes.

### 4. Dynamic updates

- For each update: flip the cell, then recompute the MST on the new island set and output its cost.

## Project Structure

```
DynamicIsleNet/
├── src/
│   └── main.cpp           # Core C++ solver (MST + dynamic updates)
├── scripts/
│   ├── build.bat          # Build solver (Windows cmd)
│   ├── run_tests.bat      # Build + run all tests (Windows cmd)
│   ├── build.ps1          # Build solver (Windows PowerShell)
│   ├── run_tests.ps1      # Build + run all tests (Windows PowerShell)
│   ├── build.sh           # Build solver (Linux/macOS)
│   └── run_tests.sh       # Build + run all tests (Linux/macOS)
├── testcases/
│   ├── input1.txt         # Small grid, 2 updates
│   ├── output1.txt
│   ├── input2.txt         # Disconnected islands → -1, then connect
│   ├── output2.txt
│   ├── input3.txt         # Edge case: 1×1 grid, 0/1 island
│   └── output3.txt
├── Makefile               # make / make test (Unix)
├── README.md              # This file
├── LICENSE                # MIT License
└── .gitignore
```

## Build & Run

### Requirements

- C++ compiler with C++11 or later (e.g. `g++`, `clang++`, or MSVC).

### Build

**Linux / macOS** (from project root):

```bash
make              # or: ./scripts/build.sh
# or manually:
g++ -std=c++17 -O2 -o solver src/main.cpp
```

**Windows:**

- **Command Prompt (cmd):** run from project root: `scripts\build.bat`
- **PowerShell:** `.\scripts\build.ps1`
- Or manually: `g++ -std=c++17 -O2 -o solver.exe src\main.cpp`

You need a C++ compiler on PATH (e.g. [MinGW](https://www.mingw-w64.org/), [MSYS2](https://www.msys2.org/), or [Visual Studio](https://visualstudio.microsoft.com/) with "Desktop development with C++").

### Run

```bash
./solver < testcases/input1.txt
```

**Windows (cmd):** `solver.exe < testcases\input1.txt`  
**Windows (PowerShell):** `Get-Content testcases\input1.txt | .\solver.exe` or `.\solver.exe < testcases\input1.txt`

### Test cases

| File        | Description |
|------------|-------------|
| `input1.txt` | 2×2 grid, 2 updates: island sinks then another rises. Output: initial MST cost, then after each update. |
| `input2.txt` | 3×3 grid, four corner islands (disconnected) → output **-1**; five updates gradually connect them → final MST costs **7** then **8**. |
| `input3.txt` | Edge case: 1×1 grid, one island then two toggles (sink/rise). Output: **0** for all (0 or 1 island → no bridges). |

### Verify

Check a single test (e.g. input1):

```bash
./solver < testcases/input1.txt > my_output.txt
diff testcases/output1.txt my_output.txt
```

To verify all test cases at once, use the script below.

### Run all tests

Builds the solver and checks every `input*.txt` against the matching `output*.txt`.

**Linux / macOS:** `make test` or `./scripts/run_tests.sh`

**Windows (Command Prompt):** `scripts\run_tests.bat`

**Windows (PowerShell):** `.\scripts\run_tests.ps1`

## Input Format

- Line 1: `N Q` (grid size, number of updates).
- Next N lines: N integers each — **stability** matrix.
- Next N lines: N integers each — **grid** (0 or 1).
- Next Q lines: `i j` — row and column (0-indexed) of the cell to **toggle** (rise/sink).

## Output Format

- Line 1: MST cost for the **initial** grid (or `-1` if disconnected).
- Next Q lines: MST cost **after each update** (or `-1` if disconnected).
- If there are 0 or 1 islands, the cost is **0**.

## Performance

- Union-Find gives near-linear time per MST computation.
- Sorting edges: **O(E log E)** with E = number of adjacent island pairs (at most ~2N² for a dense grid).
- For very large grids, incremental or dynamic MST techniques can be added later.

## Extensions

- **Diagonal bridges**: in `src/main.cpp`, set `ALLOW_DIAGONALS = true` to allow 8-neighbor edges (recompile and re-run tests; expected outputs may change).
- **Other weights**: e.g. distance-based or custom formulas.
- **Incremental MST**: only recompute affected components after an update.

## License

MIT License — see [LICENSE](LICENSE).

## Contributing

Contributions are welcome: more test cases, optimizations, or alternative algorithms (e.g. Prim’s, dynamic MST).

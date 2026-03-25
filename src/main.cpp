/**
 * DynamicIsleNet - Dynamic Archipelago MST Solver
 * Maintains minimum-cost connectivity between islands as the grid changes.
 * Uses Kruskal's algorithm with Union-Find (DSU).
 *
 * Set ALLOW_DIAGONALS to true to allow 8-neighbor (diagonal) bridges.
 */

#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

// Set to true for diagonal bridges (8 neighbors); false for orthogonal only (4).
constexpr bool ALLOW_DIAGONALS = false;

struct Edge {
    int u, v;
    long long cost;
    bool operator<(const Edge& other) const { return cost < other.cost; }
};

struct DSU {
    vector<int> parent, rank;
    int n;

    DSU(int n) : n(n), parent(n), rank(n, 0) {
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }

    bool unite(int a, int b) {
        a = find(a), b = find(b);
        if (a == b) return false;
        if (rank[a] < rank[b]) swap(a, b);
        parent[b] = a;
        if (rank[a] == rank[b]) rank[a]++;
        return true;
    }
};

int N, Q;
vector<vector<int>> grid;
vector<vector<long long>> stability;

inline int id(int i, int j) { return i * N + j; }

vector<Edge> generateEdges() {
    vector<Edge> edges;
    // Orthogonal: up, down, left, right. Optional: four diagonals.
    const int di[] = {-1, 1, 0, 0, -1, -1, 1, 1};
    const int dj[] = {0, 0, -1, 1, -1, 1, -1, 1};
    const int ndir = ALLOW_DIAGONALS ? 8 : 4;

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (grid[i][j] == 0) continue;
            int u = id(i, j);
            for (int d = 0; d < ndir; d++) {
                int ni = i + di[d], nj = j + dj[d];
                if (ni >= 0 && ni < N && nj >= 0 && nj < N && grid[ni][nj] == 1) {
                    int v = id(ni, nj);
                    if (u < v) {  // avoid duplicate edges
                        long long c = max(stability[i][j], stability[ni][nj]);
                        edges.push_back({u, v, c});
                    }
                }
            }
        }
    }
    return edges;
}

long long mstCost() {
    vector<int> islandIds;
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            if (grid[i][j] == 1) islandIds.push_back(id(i, j));

    if (islandIds.empty()) return 0;
    if (islandIds.size() == 1) return 0;

    DSU dsu(N * N);
    vector<Edge> edges = generateEdges();
    sort(edges.begin(), edges.end());

    long long total = 0;
    int components = (int)islandIds.size();
    for (int i = 0; i < (int)islandIds.size(); i++)
        dsu.parent[islandIds[i]] = islandIds[i], dsu.rank[islandIds[i]] = 0;

    for (const Edge& e : edges) {
        if (dsu.unite(e.u, e.v)) {
            total += e.cost;
            components--;
            if (components == 1) break;
        }
    }

    if (components != 1) return -1;
    return total;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);

    cin >> N >> Q;
    grid.assign(N, vector<int>(N));
    stability.assign(N, vector<long long>(N));

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            cin >> stability[i][j];

    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            cin >> grid[i][j];

    cout << mstCost() << '\n';

    for (int q = 0; q < Q; q++) {
        int i, j;
        cin >> i >> j;
        grid[i][j] = 1 - grid[i][j];
        cout << mstCost() << '\n';
    }

    return 0;
}

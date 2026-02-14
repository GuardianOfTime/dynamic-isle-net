# dynamic-isle-net
DynamicIsleNet simulates a dynamic archipelago: an N×N grid of islands (1) and water (0).  Bridges connect adjacent islands; cost = max(stability) of the two cells.  Over Q updates, islands rise or sink; after each update we compute the minimum total  bridge cost to connect all islands (MST). Uses Kruskal's algorithm and Union-Find (DSU). 

# Union-Find data structure
mutable struct UnionFind
    parent::Vector{Int}
    rank::Vector{Int}
    size::Vector{Int}
end

function UnionFind(n)
    return UnionFind(collect(1:n), zeros(Int, n), ones(Int, n))
end

function find(uf::UnionFind, x::Int)
    if uf.parent[x] != x
        uf.parent[x] = find(uf, uf.parent[x])
    end
    return uf.parent[x]
end

function union!(uf::UnionFind, x::Int, y::Int)
    root_x = find(uf, x)
    root_y = find(uf, y)

    if root_x == root_y
        return
    end

    if uf.rank[root_x] < uf.rank[root_y]
        root_x, root_y = root_y, root_x
    end

    uf.parent[root_y] = root_x
    uf.size[root_x] += uf.size[root_y]

    if uf.rank[root_x] == uf.rank[root_y]
        uf.rank[root_x] += 1
    end
end

# Helper functions
function parse_coordinates(lines)
    objects = []
    for line in lines
        coords = parse.(Int, split(line, ","))
        push!(objects, coords)
    end
    return objects
end

function calculate_distances(objects)
    n = length(objects)
    distances = []
    for i in 1:n
        for j in i+1:n
            dist = sqrt(sum((objects[i] .- objects[j]) .^ 2))
            push!(distances, (dist, i, j))
        end
    end
    sort!(distances)
    return distances
end

# Part 1
function part1(lines)
    objects = parse_coordinates(lines)
    distances = calculate_distances(objects)

    # Pick 1000 shortest distances
    edges = distances[1:1000]

    # Apply union-find
    n = length(objects)
    uf = UnionFind(n)
    for (_, i, j) in edges
        union!(uf, i, j)
    end

    # Find sizes of distinct components
    unique_roots = Set()
    for i in 1:n
        push!(unique_roots, find(uf, i))
    end

    sizes = sort([uf.size[root] for root in unique_roots], rev=true)
    println(sizes[1:3])

    return prod(sizes[1:min(3, length(sizes))])
end

# Part 2
function part2(lines)
    objects = parse_coordinates(lines)
    distances = calculate_distances(objects)

    n = length(objects)

    # Apply union-find until one big group
    uf = UnionFind(n)
    num_components = n
    last_roots = [0, 0]

    for (_, i, j) in distances
        root_i = find(uf, i)
        root_j = find(uf, j)

        if root_i != root_j
            if num_components == 2
                # This is the merge that will create one group
                last_roots = [i, j]
            end

            union!(uf, i, j)
            num_components -= 1
        end
    end

    # Return product of X coordinates of the last two components
    return objects[last_roots[1]][1] * objects[last_roots[2]][1]
end

# Read input
lines = readlines("data/input_d08")  # or this for line-by-line
println(part2(lines))

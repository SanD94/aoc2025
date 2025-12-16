function parse_graph(lines)
    graph = Dict()
    for line in lines
        parts = split(line, ": ")
        device = parts[1]
        outputs = split(parts[2])
        graph[device] = outputs
    end
    return graph
end

function count_paths_generic(graph, start, required_nodes=nothing)
    memo = Dict()

    function count_paths(node, visited_set)
        if node == "out"
            if required_nodes === nothing
                return 1
            else
                return all(n in visited_set for n in required_nodes) ? 1 : 0
            end
        end

        key = (node, visited_set)
        if haskey(memo, key)
            return memo[key]
        end

        if !haskey(graph, node)
            return 0
        end

        total = 0
        new_visited = copy(visited_set)
        if required_nodes !== nothing && node in required_nodes
            push!(new_visited, node)
        end

        for next_node in graph[node]
            total += count_paths(next_node, new_visited)
        end

        memo[key] = total
        return total
    end

    return count_paths(start, Set())
end

function part1(lines)
    graph = parse_graph(lines)
    return count_paths_generic(graph, "you")
end

function part2(lines)
    graph = parse_graph(lines)
    return count_paths_generic(graph, "svr", ["dac", "fft"])
end

# Read input
lines = readlines("data/input_d11")  # or this for line-by-line
println(part2(lines))

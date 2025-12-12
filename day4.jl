const DIRECTIONS = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

function find_accessible(grid)
    rows, cols = length(grid), length(grid[1])
    accessible = []
    for r in 1:rows
        for c in 1:cols
            if grid[r][c] == '@'
                neighbors = 0
                for (dr, dc) in DIRECTIONS
                    nr, nc = r + dr, c + dc
                    if 1 <= nr <= rows && 1 <= nc <= cols && grid[nr][nc] == '@'
                        neighbors += 1
                    end
                end
                if neighbors < 4
                    push!(accessible, (r, c))
                end
            end
        end
    end
    return accessible
end

# Part 1
function part1(lines)
    grid = [collect(line) for line in lines]
    return length(find_accessible(grid))
end

# Part 2
function part2(lines)
    grid = [collect(line) for line in lines]

    total_removed = 0
    while true
        to_remove = find_accessible(grid)

        if isempty(to_remove)
            break
        end

        for (r, c) in to_remove
            grid[r][c] = '.'
        end
        total_removed += length(to_remove)
    end

    return total_removed
end

# Read input
lines = readlines("data/input_d04")  # or this for line-by-line
println(part2(lines))

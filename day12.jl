# Part 1
function part1(lines)
    # Parse shapes (6 shapes, 3x3 each)
    shapes = Dict()
    i = 1
    for shape_idx in 0:5
        # Skip the "shape_idx:" line
        i += 1
        # Read 3 lines for the 3x3 shape
        shape = [lines[i], lines[i+1], lines[i+2]]
        shapes[shape_idx] = shape
        i += 4
    end
    # Skip empty line
    i += 1

    # Parse regions
    regions = []
    while i <= length(lines)
        line = strip(lines[i])
        if !isempty(line)
            parts = split(line)
            dims_str = rstrip(parts[1], ':')  # Remove trailing colon
            dims = split(dims_str, "x")
            width, height = parse(Int, dims[1]), parse(Int, dims[2])
            counts = parse.(Int, parts[2:end])
            push!(regions, (width, height, counts))
        end
        i += 1
    end

    # Count cells in each shape
    shape_sizes = Dict()
    for (idx, shape) in shapes
        cell_count = 0
        for row in shape
            for char in row
                if char == '#'
                    cell_count += 1
                end
            end
        end
        shape_sizes[idx] = cell_count
    end

    # Count regions that can fit all presents
    count = 0
    for (width, height, counts) in regions
        total_cells_needed = 0
        for (idx, shape_count) in enumerate(counts)
            total_cells_needed += shape_count * shape_sizes[idx-1]
        end
        region_size = width * height
        if total_cells_needed <= region_size
            count += 1
        end
    end

    return count
end

# Part 2
function part2(lines)
end

# Read input
lines = readlines("data/input_d12")
println(part1(lines))

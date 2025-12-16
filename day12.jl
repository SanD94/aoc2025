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
    print(shapes)
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

    # Convert shapes to coordinates
    function shape_to_coords(shape)
        coords = Set()
        for (r, row) in enumerate(shape)
            for (c, char) in enumerate(row)
                if char == '#'
                    push!(coords, (r - 1, c - 1))  # 0-indexed
                end
            end
        end
        return coords
    end

    # Normalize coordinates to start at (0, 0)
    function normalize(coords)
        if isempty(coords)
            return coords
        end
        min_r = minimum(r for (r, c) in coords)
        min_c = minimum(c for (r, c) in coords)
        return Set((r - min_r, c - min_c) for (r, c) in coords)
    end

    # Generate all rotations and flips
    function get_all_orientations(coords)
        orientations = Set()
        for flip in [false, true]
            current = coords
            if flip
                current = Set((r, -c) for (r, c) in current)
            end
            for _ in 1:4
                normalized = normalize(current)
                push!(orientations, normalized)
                current = Set((c, -r) for (r, c) in current)
            end
        end
        return [s for s in orientations]
    end

    # Build orientations for all shapes
    shape_orientations = Dict()
    for (idx, shape) in shapes
        coords = shape_to_coords(shape)
        shape_orientations[idx] = get_all_orientations(coords)
    end

    # Check if presents can fit in region using backtracking
    function can_fit(width, height, required_counts)
        grid = Set()

        # Flatten required shapes into list
        shape_list = []
        for (idx, count) in enumerate(required_counts)
            for _ in 1:count
                push!(shape_list, idx - 1)  # 0-indexed shape index
            end
        end

        function backtrack(idx)
            if idx > length(shape_list)
                return true
            end

            shape_idx = shape_list[idx]
            for orientation in shape_orientations[shape_idx]
                # Try all positions
                for r in 0:(height-1)
                    for c in 0:(width-1)
                        # Check if we can place this orientation at (r, c)
                        cells_to_place = []
                        can_place = true

                        for (dr, dc) in orientation
                            nr, nc = r + dr, c + dc
                            if nr >= height || nc >= width
                                can_place = false
                                break
                            end
                            if (nr, nc) in grid
                                can_place = false
                                break
                            end
                            push!(cells_to_place, (nr, nc))
                        end

                        if can_place
                            # Place shape
                            for cell in cells_to_place
                                push!(grid, cell)
                            end

                            if backtrack(idx + 1)
                                return true
                            end

                            # Remove shape
                            for cell in cells_to_place
                                delete!(grid, cell)
                            end
                        end
                    end
                end
            end
            return false
        end

        return backtrack(1)
    end

    # Count regions that can fit all presents
    count = 0
    for (width, height, counts) in regions
        if can_fit(width, height, counts)
            count += 1
        end
        print(count)
    end

    return count
end

# Part 2
function part2(lines)
end

# Read input
lines = readlines("data/input_d12")
println(part1(lines))

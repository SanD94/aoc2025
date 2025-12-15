function parse_coordinates(lines)
    coords = []
    for line in lines
        x, y = parse.(Int, split(line, ','))
        push!(coords, (x, y))
    end
    return coords
end


function extract_lines(coords)
    h_lines = []  # horizontal lines (y fixed, x varies)
    v_lines = []  # vertical lines (x fixed, y varies)
    n = length(coords)

    for i in 1:n
        x1, y1 = coords[i]
        x2, y2 = coords[i%n+1]

        if y1 == y2
            # Horizontal line: y is fixed, x changes
            push!(h_lines, (min(x1, x2), max(x1, x2), y1))
        elseif x1 == x2
            # Vertical line: x is fixed, y changes
            push!(v_lines, (x1, min(y1, y2), max(y1, y2)))
        end
    end

    return h_lines, v_lines
end

function rectangle_intersects_boundary(x1, y1, x2, y2, h_lines, v_lines)
    min_x, max_x = minmax(x1, x2)
    min_y, max_y = minmax(y1, y2)

    # Check if any polygon edge intersects rectangle perimeter
    for (x_min, x_max, y) in h_lines
        # Polygon horizontal edge
        if min_y < y < max_y
            if !(x_max <= min_x || x_min >= max_x)
                return true
            end
        end
    end

    for (x, y_min, y_max) in v_lines
        # Polygon vertical edge
        if min_x < x < max_x
            if !(y_max <= min_y || y_min >= max_y)
                return true
            end
        end
    end

    return false
end

function part1(lines)
    coords = parse_coordinates(lines)
    max_area = 0
    n = length(coords)

    for i in 1:n
        for j in i+1:n
            p1 = coords[i]
            p2 = coords[j]
            area = (abs(p2[1] - p1[1]) + 1) * (abs(p2[2] - p1[2]) + 1)
            max_area = max(max_area, area)
        end
    end

    return max_area
end

function part2(lines)
    coords = parse_coordinates(lines)
    h_lines, v_lines = extract_lines(coords)
    max_area = 0
    n = length(coords)

    for i in 1:n
        for j in i+1:n
            p1 = coords[i]
            p2 = coords[j]

            if !rectangle_intersects_boundary(p1[1], p1[2], p2[1], p2[2], h_lines, v_lines)
                area = (abs(p2[1] - p1[1]) + 1) * (abs(p2[2] - p1[2]) + 1)
                max_area = max(max_area, area)
            end
        end
    end

    return max_area
end

# Read input
lines = readlines("data/input_d09")
coords = parse_coordinates(lines)
println(part1(lines))
println(part2(lines))

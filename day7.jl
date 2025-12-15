# Part 1
function part1(lines)
    # Find source position (S in line 1)
    source_pos = findfirst('S', lines[1])

    count = 0

    # Start with the beam at source position (| generated below S)
    beams = Set([source_pos])

    # Process from line 2 onwards
    for line_idx = 2:length(lines)
        new_beams = Set()

        for beam_pos in beams
            if beam_pos <= length(lines[line_idx])
                if lines[line_idx][beam_pos] == '^'
                    # ^ crossed by |, splits into two beams (remove original)
                    count += 1
                    if beam_pos > 1
                        push!(new_beams, beam_pos - 1)
                    end
                    if beam_pos < length(lines[line_idx])
                        push!(new_beams, beam_pos + 1)
                    end
                    # Original beam is not added to new_beams
                else
                    # | continues downward
                    push!(new_beams, beam_pos)
                end
            end
        end

        beams = new_beams
        if isempty(beams)
            break
        end
    end

    return count
end

# Part 2
function part2(lines)
    n_lines = length(lines)

    # Start from bottom line: 1 configuration at each position
    dp_below = ones(Int, length(lines[n_lines]))

    # Process upward from second-to-last line to first line
    for line_idx in n_lines-1:-1:1
        curr_line = lines[line_idx]
        next_line = lines[line_idx+1]

        dp_curr = zeros(Int, length(curr_line))

        # For each position in the line below
        for pos in 1:length(next_line)
            if next_line[pos] == '^'
                # ^ splits configurations: paths go left and right
                if pos > 1
                    dp_curr[pos] += dp_below[pos-1]
                end
                if pos < length(next_line)
                    dp_curr[pos] += dp_below[pos+1]
                end
            else
                dp_curr[pos] = dp_below[pos]
            end
        end

        dp_below = dp_curr
    end

    # Return configurations reaching the source S
    source_pos = findfirst('S', lines[1])
    return dp_below[source_pos]
end

# Read input
lines = readlines("data/input_d07")  # or this for line-by-line
println(part2(lines))

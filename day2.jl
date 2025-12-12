function parse_input(line)
    [Tuple(parse.(Int, split(pair, "-"))) for pair in split(line, ",")]
end

function next_repeated_sequence_exact(start::Int, max_val::Int)
    s = string(start)
    len = length(s)

    if len % 2 == 1
        # Odd digits → next has even digits (len + 1)
        new_len = len + 1
        pattern_len = div(new_len, 2)
        pattern = "1" * "0"^(pattern_len - 1)
    else
        # Even digits
        pattern_len = div(len, 2)
        pattern = s[1:pattern_len]
        candidate = parse(Int, pattern * pattern)
        if candidate >= start && candidate <= max_val
            return candidate
        end

        # Try next pattern
        pattern_int = parse(Int, pattern) + 1
        pattern = string(pattern_int)
        if length(pattern) > pattern_len
            # Pattern overflowed, go to next even digit count
            new_len = len + 2
            pattern_len = div(new_len, 2)
            pattern = "1" * "0"^(pattern_len - 1)
        end
    end

    candidate = parse(Int, pattern * pattern)
    return candidate <= max_val ? candidate : nothing
end

function next_repeated_sequence(start::Int, max_val::Int)
    s = string(start)
    len = length(s)

    # Generate all repeated sequences for current digit count
    candidates = Int[]
    for pattern_len in 1:div(len, 2)
        if len % pattern_len != 0
            continue
        end
        pattern = s[1:pattern_len]
        candidate = parse(Int, pattern^(div(len, pattern_len)))
        if start <= candidate <= max_val
            push!(candidates, candidate)
        end
        pattern = string(parse(Int, pattern) + 1)
        if length(pattern) > pattern_len
            continue
        end
        candidate = parse(Int, pattern^(div(len, pattern_len)))
        if start <= candidate <= max_val
            push!(candidates, candidate)
        end
    end

    if !isempty(candidates)
        return minimum(candidates)
    end

    # Move to next digit count and find smallest repeated sequence
    new_len = len + 1
    for pattern_len in reverse(1:div(new_len, 2))
        if new_len % pattern_len != 0
            continue
        end
        pattern = "1" * "0"^(pattern_len - 1)
        candidate = parse(Int, pattern^(div(new_len, pattern_len)))
        if candidate <= max_val
            return candidate
        end
    end

    nothing
end



# Part 1
function part1(line)
    data = parse_input(line)
    total = 0
    for (id0, id1) in data
        n = next_repeated_sequence_exact(id0, id1)
        while n !== nothing
            total += n
            n = next_repeated_sequence_exact(n + 1, id1)
        end
    end
    total
end

# Part 2
function part2(line)
    data = parse_input(line)
    total = 0
    for (id0, id1) in data
        n = next_repeated_sequence(id0, id1)
        while n !== nothing
            total += n
            n = next_repeated_sequence(n + 1, id1)
        end
    end
    total
end

# Read input
line = readline("data/input_d02")
println(part2(line))

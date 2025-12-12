function parse_input(line)
    [Tuple(parse.(Int, split(pair, "-"))) for pair in split(line, ",")]
end

function is_repeated_sequence(n::Int)
    s = string(n)
    len = length(s)

    # Check if exactly 2 repetitions (pattern length = len/2)
    if len % 2 == 0
        pattern_len = div(len, 2)
        pattern = s[1:pattern_len]
        return pattern * pattern == s
    end
    false
end

function next_repeated_sequence(start::Int, max_val::Int)
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



# Part 1
function part1(line)
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

# Part 2
function part2(line)
end

# Read input
line = readline("data/input_d02")
println(part1(line))

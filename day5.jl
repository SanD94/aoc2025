function parse_input(lines)
    sep_idx = findfirst(isempty, lines)
    pairs = [(parse(Int, split(line, "-")[1]), parse(Int, split(line, "-")[2]))
             for line in lines[1:sep_idx-1]]
    numbers = [parse(Int, line) for line in lines[sep_idx+1:end]]
    pairs, numbers

end

# Part 1
function part1(lines)
    pairs, numbers = parse_input(lines)
    count(n -> any(p -> p[1] <= n <= p[2], pairs), numbers)
end

# Part 2
function part2(lines)
    pairs, _ = parse_input(lines)

    sorted = sort(pairs, by=first)
    merged = [sorted[1]]
    for (lo, hi) in sorted[2:end]
        if lo <= merged[end][2] + 1
            merged[end] = (merged[end][1], max(merged[end][2], hi))
        else
            push!(merged, (lo, hi))
        end
    end

    sum(hi - lo + 1 for (lo, hi) in merged)
end

# Read input
lines = readlines("data/input_d05")
println(part2(lines))

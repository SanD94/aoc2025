# Part 1
function part1(lines)
    total = 0
    for line in lines
        digits = line
        max_num = maximum(parse(Int, string(digits[i], digits[j]))
                          for i in 1:length(digits) for j in 1:length(digits) if i < j)
        total += max_num
    end
    return total
end

# Part 2
function part2(lines)
end

# Read input
lines = readlines("data/input_d03")  # or this for line-by-line
println(part1(lines))

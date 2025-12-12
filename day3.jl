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
    total = 0
    for line in lines
        digits = line
        b, e = 1, length(line)
        selected_indices = Int[]
        for digit in 9:-1:0
            cur_char = Char('0' + digit)
            cur_b, cur_e = b, e
            for i in b:e
                if length(selected_indices) == 12
                    break
                end
                if cur_char == digits[i]
                    push!(selected_indices, i)
                    left = 12 - length(selected_indices)
                    if i + left > e
                        cur_e = i - 1
                        append!(selected_indices, collect(i+1:e))
                        break
                    else
                        cur_b = i + 1
                    end
                end
            end
            b, e = cur_b, cur_e
        end
        sort!(selected_indices)
        selected_digits = digits[selected_indices]
        num = parse(Int, string(selected_digits...))
        total += num
    end
    return total
end

# Read input
lines = readlines("data/input_d03")  # or this for line-by-line
println(part2(lines))

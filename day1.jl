# Part 1
function part1(lines)
    # Your solution here
    cnt = 0
    cur_dial = 50
    for line in lines
        # first character 'L' or 'R', the rest is number
        dir = line[1] == 'L' ? -1 : 1
        num = parse(Int, line[2:end])
        cur_dial += dir * num
        if cur_dial % 100 == 0
            cnt += 1
        end
    end
    return cnt
end

# Part 2
function part2(lines)
    # Your solution here
    return 0
end

# Read input
lines = readlines("data/input_d01")  # or this for line-by-line
println(part1(lines))



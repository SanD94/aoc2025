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
    cnt = 0
    cur_dial = 50
    for line in lines
        # first character 'L' or 'R', the rest is number
        dir = line[1] == 'L' ? -1 : 1
        num = parse(Int, line[2:end])

        cnt += div(num, 100)
        num %= 100
        next_dial = cur_dial + dir * num
        if cur_dial != 0 && (next_dial >= 100 || next_dial <= 0)
            cnt += 1
        end
        cur_dial = mod(next_dial, 100)
    end
    return cnt
end

# Read input
lines = readlines("data/input_d01")  # or this for line-by-line
println(part2(lines))



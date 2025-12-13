# Part 1
function part1(lines)
    # Parse numbers from each line (all except last)
    numbers = [parse.(Int, split(line)) for line in lines[1:end-1]]

    # Parse operations from last line
    operations = split(lines[end])

    # Apply operations: for each column index, apply the corresponding operation
    results = []
    for col_idx in 1:length(operations)
        op = operations[col_idx]
        values = [nums[col_idx] for nums in numbers]

        if op == "*"
            result = prod(values)
        elseif op == "+"
            result = sum(values)
        end

        push!(results, result)
    end

    return sum(results)
end

# Part 2
function part2(lines)
    # Get all lines except the operations line
    data_lines = lines[1:end-1]
    ops_line = lines[end]

    # Find the maximum line length to process columns
    max_len = maximum(length.(data_lines))
    ops_len = length.(ops_line)

    # Process columns from right to left
    results = []
    nums = Int[]
    col_idx = 1
    for pos in max_len:-1:1
        # Extract digits from this column position (top to bottom)
        digits_str = ""
        for line in data_lines
            digits_str *= line[pos]
        end

        # Remove spaces and check if we have digits
        digits_str = replace(digits_str, " " => "")
        if !isempty(digits_str)
            number = parse(Int, digits_str)
            push!(nums, number)
        end


        if pos <= ops_len && ops_line[pos] !== ' '
            if ops_line[pos] == '*'
                result = prod(nums)
            elseif ops_line[pos] == '+'
                result = sum(nums)
            end
            nums = []
            push!(results, result)
        end

    end

    return sum(results)
end

# Read input
lines = readlines("data/input_d06")  # or this for line-by-line
println(part2(lines))

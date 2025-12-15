# Part 1
function part1(lines)
    total_presses = 0

    for line in lines
        # Parse target state
        state_match = match(r"\[([\.\#]+)\]", line)
        state_str = reverse(replace(state_match.captures[1], '.' => '0', '#' => '1'))
        target = parse(Int, state_str, base=2)
        initial = 0  # All lights off

        # Parse button definitions
        buttons = Int[]
        for button_match in eachmatch(r"\(([0-9,]+)\)", line)
            indices = parse.(Int, split(button_match.captures[1], ","))
            button_mask = 0
            for idx in indices
                button_mask |= (1 << idx)
            end
            push!(buttons, button_mask)
        end

        # Try all 2^n combinations
        min_presses = 20
        for combo in 0:(1<<length(buttons)-1)
            state = initial
            for i in 0:length(buttons)-1
                if (combo & (1 << i)) != 0
                    state ⊻= buttons[i+1]
                end
            end
            if state == target
                min_presses = min(min_presses, count_ones(combo))
            end
        end

        total_presses += min_presses
    end

    total_presses
end

# Part 2
function part2(lines)
    total_presses = 0

    for line in lines
        # Parse counter requirements
        counter_match = match(r"\{([0-9,]+)\}", line)
        targets = parse.(Int, split(counter_match.captures[1], ","))

        # Parse button definitions (now indicate which counters they affect)
        buttons = []
        for button_match in eachmatch(r"\(([0-9,]+)\)", line)
            indices = parse.(Int, split(button_match.captures[1], ","))
            push!(buttons, Tuple(indices))
        end

        # Compute radix offsets for mixed-radix encoding
        radix_offsets = ones(Int, length(targets))
        for i in 2:length(targets)
            radix_offsets[i] = radix_offsets[i-1] * (targets[i-1] + 1)
        end

        # Convert state vector to single integer
        function state_to_int(state)
            result = 0
            for i in 1:length(state)
                result += state[i] * radix_offsets[i]
            end
            result
        end

        # Convert integer back to state vector
        function int_to_state(val)
            state = zeros(Int, length(targets))
            for i in 1:length(targets)
                state[i] = div(val, radix_offsets[i]) % (targets[i] + 1)
            end
            state
        end

        target_val = state_to_int(targets)

        # BFS on integer state space
        visited_dict = Dict(0 => 0)
        queue = [0]
        min_presses = typemax(Int)

        while !isempty(queue)
            current_val = popfirst!(queue)
            current_presses = visited_dict[current_val]

            if current_val == target_val
                min_presses = current_presses
                break
            end

            current_state = int_to_state(current_val)

            # Try each button
            for button in buttons
                next_state = copy(current_state)
                for counter_idx in button
                    next_state[counter_idx+1] += 1
                end

                next_val = state_to_int(next_state)

                # Prune if any counter exceeds its target
                if any(next_state[i] > targets[i] for i in 1:length(targets))
                    continue
                end

                if !haskey(visited_dict, next_val)
                    visited_dict[next_val] = current_presses + 1
                    push!(queue, next_val)
                end
            end
        end
        println(min_presses)

        total_presses += min_presses
    end

    total_presses
end

# Read input
lines = readlines("data/input_d10")  # or this for line-by-line
println(part2(lines))

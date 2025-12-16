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

CUSTOM_MAX = 1000000
encode_list(bits) = parse(Int, join(bits), base=2)
to_parity(nums) = [n % 2 for n in nums]

function get_combo_list(buttons, targets)
    num_buttons = length(buttons)

    # Precompute all button combination effects
    combo_effects = []
    for combo in 0:(1<<num_buttons-1)
        effects = zeros(Int, length(targets))
        button_press = 0
        for i in 0:num_buttons-1
            if (combo & (1 << i)) != 0
                button_press += 1
                for counter_idx in buttons[i+1]
                    effects[counter_idx+1] += 1
                end
            end
        end

        parity_effect = effects |> to_parity |> encode_list
        parity_target = targets |> to_parity |> encode_list

        if parity_effect == parity_target && button_press > 0
            push!(combo_effects, (button_press, effects))
        end
    end
    return combo_effects
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


        # DP with memoization: f(remaining_targets) = min presses to reach remaining_targets
        memo = Dict()
        combo_list = Vector{Any}(undef, 1 << 16)


        function min_presses_dp(remaining)
            remaining_tuple = Tuple(remaining)

            # Base case: all targets reached
            if all(remaining[i] == 0 for i in 1:length(remaining))
                return 0
            end

            if any(left < 0 for left in remaining)
                return CUSTOM_MAX
            end

            # Check memo
            if haskey(memo, remaining_tuple)
                return memo[remaining_tuple]
            end

            result = CUSTOM_MAX

            odd_check = any(left % 2 == 1 for left in remaining)
            if !odd_check
                sub_res = min_presses_dp(div.(remaining, 2))
                result = 2 * sub_res
            end

            parity_remaining = remaining |> to_parity |> encode_list

            if !isassigned(combo_list, parity_remaining + 1)
                combo_list[parity_remaining+1] = get_combo_list(buttons, remaining)
            end

            combo_effects = combo_list[parity_remaining+1]
            # Try each button combination
            for (button_press, effect) in combo_effects

                sub_result = min_presses_dp(remaining .- effect)
                result = min(result, button_press + sub_result)
            end


            memo[remaining_tuple] = result
            result
        end


        min_presses = min_presses_dp(targets)
        println(targets, " ", min_presses)
        total_presses += min_presses
    end

    total_presses
end

# Read input
lines = readlines("data/input_d10")  # or this for line-by-line
println(part2(lines))

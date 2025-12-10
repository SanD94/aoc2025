## Parsing Tricks
# Split and parse numbers
nums = parse.(Int, split(line))  # broadcast parse over array

# Regex matching
m = match(r"(\d+)", line)
num = parse(Int, m.captures[1])

# Character arrays (strings are not arrays in Julia!)
chars = collect(line)  # "abc" -> ['a', 'b', 'c']

## Collections
# Arrays (1-indexed!)
arr = [1, 2, 3]
push!(arr, 4)  # ! means mutation
pop!(arr)

# Dictionaries
dict = Dict("key" => value)
get(dict, "key", default)  # with default

# Sets
s = Set([1, 2, 3])
union(s1, s2)
intersect(s1, s2)

## Compherensions
# List comprehension
squares = [x^2 for x in 1:10]

# With conditions
evens = [x for x in 1:10 if x % 2 == 0]

# Dict comprehension
d = Dict(x => x^2 for x in 1:5)

## Useful Patterns
# Enumerate with index
for (i, line) in enumerate(lines)
    println("Line $i: $line")  # $ for interpolation
end

# Zip multiple arrays
for (a, b) in zip(arr1, arr2)
    # ...
end

# Sum/count with conditions
total = sum(x for x in arr if x > 0)
count(x -> x > 0, arr)  # lambda syntax

# Find operations
findfirst(x -> x > 5, arr)  # returns index or nothing
filter(x -> x > 5, arr)     # returns filtered array


## Grid Problems
# Parse grid
grid = [collect(line) for line in lines]  # Vector of Vectors
# or as matrix
grid = reduce(vcat, permutedims.(collect.(lines)))

# Neighbors (4-directional)
dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
for (dr, dc) in dirs
    nr, nc = r + dr, c + dc
    # check bounds, etc.
end

## Packages you might want
# In REPL, press ]
# using DataStructures  # PriorityQueue, DefaultDict, etc.
# using Combinatorics   # permutations, combinations
# using Graphs          # graph algorithms

## Pro Moves
# Pipe operator (like R's %>%)
result = data |> filter_func |> map_func |> sum

# Splatting
nums = [1, 2, 3]
max(nums...)  # unpacks array as arguments

# Ranges for big numbers
sum(1:1_000_000)  # doesn't allocate array!

# @show macro for debugging
@show variable  # prints "variable = value"
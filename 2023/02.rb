# https://adventofcode.com/2023/day/2

input = File.read('inputs/02.txt').lines

# PART I

cubes = { "red" => 12, "green" => 13, "blue" => 14 }
sum   = 0

input.each do |line|
  _, id, *sets = line.scan(/\w+/)

  possible = sets
    .each_slice(2)
    .all? { |n, colour| cubes[colour] >= n.to_i }

  sum += id.to_i if possible
end

p sum


# PART II

sum = 0

input.each do |line|
  max_cubes   = { "red" => 0, "green" => 0, "blue" => 0 }
  _, _, *sets = line.scan(/\w+/)

  sets.each_slice(2) do |n, colour|
    max_cubes[colour] = n.to_i if max_cubes[colour] < n.to_i
  end

  power = max_cubes.values.reduce(&:*)
  sum   += power
end

p sum

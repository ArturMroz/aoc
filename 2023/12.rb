# https://adventofcode.com/2023/day/12

input = File.readlines('inputs/12.txt')

def count_valid_configurations(springs_map, checksum, cache)
  if springs_map.nil? || springs_map.empty?
    return checksum.empty? ? 1 : 0
  end

  if checksum.empty?
    return springs_map.include?('#') ? 0 : 1
  end

  return cache[[springs_map, checksum]] if cache.key?([springs_map, checksum])

  result = 0

  if springs_map[0] == '.' || springs_map[0] == '?'
    result += count_valid_configurations(springs_map[1..], checksum, cache)
  end

  if springs_map[0] == '#' || springs_map[0] == '?'
    run_length                        = checksum[0]
    enough_springs_left               = run_length <= springs_map.length
    all_springs_in_run_are_broken     = springs_map[...run_length].chars.none?('.')
    first_spring_after_run_is_working = run_length == springs_map.length || springs_map[run_length] != '#'

    run_is_valid = enough_springs_left && all_springs_in_run_are_broken && first_spring_after_run_is_working

    result += count_valid_configurations(springs_map[run_length + 1..], checksum[1..], cache) if run_is_valid
  end

  cache[[springs_map, checksum]] = result
end

def solve(input, part2)
  input.sum do |line|
    springs_map, checksum = line.split
    checksum              = checksum.split(',').map(&:to_i)

    if part2
      springs_map = ([springs_map] * 5).join('?')
      checksum *= 5
    end

    count_valid_configurations(springs_map, checksum, {})
  end
end

# PART I

p solve(input, false)

# PART II

p solve(input, true)

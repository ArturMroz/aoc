# https://adventofcode.com/2021/day/1

input = File.read('inputs/01.txt')
  .split("\n")
  .map(&:to_i)

# PART I

result = input
  .each_cons(2)
  .count { |a, b| a < b }

p result

# PART II

result = input
  .each_cons(3)
  .map(&:sum)
  .each_cons(2)
  .count { |a, b| a < b }

p result

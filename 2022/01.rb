# https://adventofcode.com/2022/day/1

input = File.read('inputs/01.txt').split("\n\n")

# PART I

result = input
  .map { |cals| cals.split.map(&:to_i).sum }
  .max

p result

# PART II

result = input
  .map { |cals| cals.split.map(&:to_i).sum }
  .sort
  .last(3)
  .sum

p result

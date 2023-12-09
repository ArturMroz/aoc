# https://adventofcode.com/2023/day/6

input = File.read('inputs/06.txt').lines

# PART I

times, records = input.map { |line| line.scan(/\d+/).map(&:to_i) }

total = times
  .zip(records)
  .map do |time, record|
    (1..time).count { |speed| (time - speed) * speed > record }
  end
  .reduce(:*)

p total

# PART II, peasant brute force

time, record = input.map { |line| line.scan(/\d+/).join.to_i }

total = (1..time).count { |speed| (time - speed) * speed > record }

p total

# PART II, distinguished gentleman math

high = ((time + Math.sqrt((time**2) - (4 * record))) / 2).floor
low  = ((time - Math.sqrt((time**2) - (4 * record))) / 2).ceil

p high - low + 1

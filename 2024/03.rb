# https://adventofcode.com/2024/day/3

input = File.read('inputs/03.txt')

# PART I

sum = input
  .scan(/mul\(\d+,\d+\)/)
  .map { |mul| mul.scan(/\d+/).map(&:to_i) }
  .sum { |a, b| a * b }

p sum

# PART II

ops = input.scan(/mul\(\d+,\d+\)|don't\(\)|do\(\)/)

enabled = true
sum     = 0

ops.each do |op|
  if op == 'do()'
    enabled = true
  elsif op == "don't()"
    enabled = false
  elsif enabled
    a, b = op.scan(/\d+/).map(&:to_i)
    sum += a * b
  end
end

p sum

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
  case op
  when 'do()'
    enabled = true
  when "don't()"
    enabled = false
  else
    a, b = op.scan(/\d+/).map(&:to_i)
    sum += a * b if enabled
  end
end

p sum

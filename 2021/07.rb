# https://adventofcode.com/2021/day/7

input = File.read('inputs/07.txt').scan(/\d+/).map(&:to_i)

# PART I

sums = (input.min..input.max).map do |i|
  input.sum { |j| (j - i).abs }
end

p sums.min

# PART II

def triangular_sum(n) = n * (n + 1) / 2

sums = (input.min..input.max).map do |i|
  input.sum do |j|
    diff = (j - i).abs
    triangular_sum(diff)
  end
end

p sums.min

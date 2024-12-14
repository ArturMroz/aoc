# https://adventofcode.com/2024/day/13

input = File.read('inputs/13.txt').split("\n\n")

require 'matrix'

def solve(a, b, prize, part)
  coefficient = Matrix[[a[0], b[0]], [a[1], b[1]]]
  constant    = Matrix[[prize[0]], [prize[1]]]

  constant.map! { |e| e + 10_000_000_000_000 } if part == :part2

  result = coefficient.inverse * constant

  x = result[0, 0]
  y = result[1, 0]

  if x.denominator == 1 && y.denominator == 1
    (3 * x).to_i + y.to_i
  else
    0
  end
end

machines = input.map do |group|
  group.lines.map { |line| line.scan(/\d+/).map(&:to_i) }
end

total_p1 = machines.sum { |a, b, prize| solve(a, b, prize, :part1) }
total_p2 = machines.sum { |a, b, prize| solve(a, b, prize, :part2) }

p total_p1
p total_p2

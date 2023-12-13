# https://adventofcode.com/2023/day/9

input = File.read('inputs/09.txt').lines

history = input.map { |line| line.split.map(&:to_i) }

part1_result = 0
part2_result = 0

history.each do |h|
  steps = [h]

  until steps.last.all?(&:zero?)
    steps << steps.last.each_cons(2).map { |a, b| b - a }
  end

  steps.reverse.each_cons(2) do |step, next_step|
    next_step << (next_step.last + step.last)
    next_step.unshift(next_step.first - step.first)
  end

  part1_result += steps.first.last
  part2_result += steps.first.first
end

p part1_result
p part2_result

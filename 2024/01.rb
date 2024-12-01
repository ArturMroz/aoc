# https://adventofcode.com/2024/day/1

input = File.read('inputs/01.txt').lines.map { |line| line.split.map(&:to_i) }

left, right = input.transpose

# PART I

distance = left.sort.zip(right.sort).sum { |a, b| (a - b).abs }

p distance

# PART II

freqs = right.tally

similarity_score = left.sum { |num| num * freqs.fetch(num, 0) }

p similarity_score

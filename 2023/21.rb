# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2023/day/21

input = File.read('inputs/21.txt')

Grid   = input.split("\n").map(&:chars)
Width  = Grid[0].size
Height = Grid.size

def find_start
  Grid.each_with_index do |row, y|
    row.each_with_index do |col, x|
      return [x, y] if col == 'S'
    end
  end
end

def reachable?(x, y)
  Grid[y % Height][x % Width] == '.'
end

start = find_start
Grid[start[1]][start[0]] = '.'

# PART I

pos = [start]

64.times do
  next_pos = pos.flat_map do |x, y|
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].filter do |nx, ny|
      reachable?(nx, ny)
    end
  end

  pos = next_pos.uniq
end

p1_answer = pos.size

p p1_answer

# PART II

# the first tile is completed after 65 steps
# every next tile layer is completed after 131 steps
# (26501365 - 65) / 131 = 202300
# calculate answers for the first 3 layers so that we can extrapolate the final answer

pos = [start]

step_sizes    = 3.times.map { |i| 65 + (131 * i) }
steps_to_take = step_sizes.last

sizes = []

(1..steps_to_take).each do |i|
  next_pos = pos.flat_map do |x, y|
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].filter do |nx, ny|
      reachable?(nx, ny)
    end
  end

  pos = next_pos.uniq

  sizes << pos.size if step_sizes.include?(i)
end

history = [sizes]

history << history.last.each_cons(2).map { |a, b| b - a } until history.last.uniq.size == 1

cur = history.first.last
a   = history[1].last
b   = history[2].last
i   = history.first.size - 1

num_steps = 65 + (i * 131)

until num_steps == 26_501_365
  a += b
  cur += a
  i += 1
  num_steps = 65 + (i * 131)
end

p2_answer = cur

p p2_answer

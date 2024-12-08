# frozen_string_literal: true

# https://adventofcode.com/2024/day/6

input = File.read('inputs/06.txt').split("\n")

DIR_CHANGE = {
  up: :right,
  down: :left,
  left: :up,
  right: :down
}.freeze

def walk(grid, start_pos)
  seen = Array.new(grid.size) { Array.new(grid[0].size, nil) }

  pos = start_pos.dup
  dir = :up

  seen[pos[1]][pos[0]] = dir

  loop do
    x, y = pos

    case dir
    when :up    then y -= 1
    when :down  then y += 1
    when :left  then x -= 1
    when :right then x += 1
    end

    if y < 0 || y >= grid.size || x < 0 || x >= grid[0].size
      # found the way out
      return [seen, false]
    end

    if grid[y][x]
      # hit obstacle, change direction
      dir = DIR_CHANGE[dir]
    else
      pos[0] = x
      pos[1] = y

      if dir == seen[y][x] && pos != start_pos
        # found the loop, bail
        return [seen, true]
      end

      seen[y][x] = dir
    end
  end
end

start_pos = nil
grid      = Array.new(input.size) { Array.new(input.size, 0) }

input.each_with_index do |row, y|
  row.chars.each_with_index do |col, x|
    grid[y][x] = col == '#'

    start_pos = [x, y] if col == '^'
  end
end

# PART I

seen, _ = walk(grid, start_pos)

num_distinct_positions = seen.sum { |row| row.compact.count }

p num_distinct_positions

# PART II

num_obstruction_positions = 0

grid.each_index do |y|
  grid[y].each_index do |x|
    next if grid[y][x] || !seen[y][x]

    grid[y][x] = true # add obstacle at (x, y)

    _, found_loop = walk(grid, start_pos)
    num_obstruction_positions += 1 if found_loop

    grid[y][x] = false # remove obstacle
  end
end

p num_obstruction_positions

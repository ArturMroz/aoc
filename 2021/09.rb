# frozen_string_literal: true

# https://adventofcode.com/2021/day/9

input = File.read('inputs/09.txt').split("\n")
grid  = input.map { |line| line.chars.map(&:to_i) }

# PART I

low_points = []

grid.each_with_index do |row, y|
  row.each_with_index do |col, x|
    next if x - 1 >= 0 && grid[y][x - 1] <= col
    next if x + 1 < row.size && grid[y][x + 1] <= col
    next if y - 1 >= 0 && grid[y - 1][x] <= col
    next if y + 1 < grid.size && grid[y + 1][x] <= col

    low_points << [x, y]
  end
end

p low_points.map { |x, y| grid[y][x] + 1 }.sum

# PART II

def flood_fill(grid, start_x, start_y)
  seen  = Set.new
  queue = [[start_x, start_y]]

  until queue.empty?
    x, y = queue.pop
    seen << [x, y]

    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
      nx = x + dx
      ny = y + dy

      next if nx < 0 || ny < 0 || ny >= grid.size || nx >= grid[0].size
      next if seen.include?([nx, ny]) || grid[ny][nx] == 9

      queue << [nx, ny]
    end
  end

  seen.size
end

basins = low_points.map { |x, y| flood_fill(grid, x, y) }

p basins.max(3).reduce(:*)

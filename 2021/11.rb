# frozen_string_literal: true

# https://adventofcode.com/2021/day/11

input = File.read('inputs/11.txt').split("\n")
grid  = input.map { |line| line.chars.map(&:to_i) }

num_flashes = 0

neighbor_offsets = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

(1..).each do |step|
  flashed = []

  # increase all octopuses' energy by 1
  grid.each_index do |y|
    grid[y].each_index do |x|
      grid[y][x] += 1
      flashed << [x, y] if grid[y][x] > 9
    end
  end

  # process flashing chain reaction
  seen = Set.new
  until flashed.empty?
    x, y = flashed.pop

    next if seen.include?([x, y])

    num_flashes += 1
    seen << [x, y]

    neighbor_offsets.each do |dx, dy|
      nx = x + dx
      ny = y + dy

      next if nx < 0 || ny < 0 || nx >= grid[0].size || ny >= grid.size

      grid[ny][nx] += 1

      flashed << [nx, ny] if grid[ny][nx] > 9
    end
  end

  # set all octopuses that flashed back to 0
  seen.each { |x, y| grid[y][x] = 0 }

  # PART I
  p num_flashes if step == 100

  # PART II
  if grid.flatten.all?(&:zero?)
    p step
    break
  end
end

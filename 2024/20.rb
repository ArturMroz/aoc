# https://adventofcode.com/2024/day/20

grid = File.read('inputs/20.txt').split("\n").map(&:chars)

DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

def in_bounds?(grid, x, y)
  y >= 0 && y < grid.size && x >= 0 && x < grid[0].size
end

def bfs(grid, start, target)
  q    = [start]
  seen = [start].to_set
  prev = {}

  until q.empty?
    cur = q.pop
    x, y = cur

    DIRS.map { |dx, dy| [x + dx, y + dy] }.each do |neighbour|
      nx, ny = neighbour

      next if grid[ny][nx] == '#'
      next if seen.include?(neighbour)

      seen << neighbour

      prev[neighbour] = cur

      if neighbour == target
        path = []
        while neighbour
          path << neighbour
          neighbour = prev[neighbour]
        end

        return path.reverse
      end

      q << neighbour
    end
  end
end

def manhattan_points(grid, (x, y), max_distance)
  points = []

  (-max_distance..max_distance).each do |dx|
    (-max_distance..max_distance).each do |dy|
      if dx.abs + dy.abs <= max_distance &&
         in_bounds?(grid, x + dx, y + dy) &&
         grid[y + dy][x + dx] != '#'
        points << [[x + dx, y + dy], dx.abs + dy.abs]
      end
    end
  end

  points
end

def get_num_cheats(grid, path, costs, cheat_distance)
  num_cheats = 0

  path.each do |point|
    neighbours = manhattan_points(grid, point, cheat_distance)

    neighbours.each do |neighbour, dist|
      cost_diff = costs[point] - costs[neighbour] - dist
      num_cheats += 1 if cost_diff >= 100
    end
  end

  num_cheats
end

start_position = nil
end_position   = nil

grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    if char == 'S'
      start_position = [x, y]
    elsif char == 'E'
      end_position = [x, y]
    end
  end
end

path  = bfs(grid, start_position, end_position)
costs = path.map.with_index { |point, i| [point, i] }.to_h

# PART I
p get_num_cheats(grid, path, costs, 2)

# PART II
p get_num_cheats(grid, path, costs, 20)

# frozen_string_literal: true

# https://adventofcode.com/2021/day/15

grid = File.read('inputs/15.txt').split("\n").map { |line| line.chars.map(&:to_i) }

require '../ds/priority_queue'

OFFSETS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

def dijkstra(grid, start, target)
  q    = PriorityQueue.new
  dist = Hash.new(1_000_000)

  dist[start] = 0

  q.push(start, 0)

  until q.empty?
    u = q.pop

    return dist[u] if u == target

    x, y = u
    neighbours = OFFSETS.map { |dx, dy| [x + dx, y + dy] }

    neighbours.each do |v|
      vx, vy = v

      next unless vx.between?(0, grid[0].size - 1) && vy.between?(0, grid.size - 1)

      alt = dist[u] + grid[vy][vx]

      if alt < dist[v]
        dist[v] = alt
        q.push(v, alt)
      end
    end
  end
end

width  = grid[0].size
height = grid.size

# PART I

start  = [0, 0]
target = [width - 1, height - 1]

p dijkstra(grid, start, target)

# PART II

scale    = 5
big_grid = Array.new(height * scale) { Array.new(width * scale, 0) }

scale.times do |sy|
  scale.times do |sx|
    height.times do |y|
      width.times do |x|
        val = grid[y][x] + sy + sx
        val -= 9 if val > 9

        big_grid[y + (sy * height)][x + (sx * width)] = val
      end
    end
  end
end

start  = [0, 0]
target = [big_grid[0].size - 1, big_grid.size - 1]

p dijkstra(big_grid, start, target)

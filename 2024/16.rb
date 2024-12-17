# https://adventofcode.com/2024/day/16

grid = File.read('inputs/16.txt').split("\n").map(&:chars)

DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

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

require '../ds/priority_queue'

def dijkstra(grid, start, target)
  start_node = [start, [1, 0]]

  q = PriorityQueue.new
  q.push(start_node, 0)

  dist = Hash.new(Float::INFINITY)
  dist[start_node] = 0

  paths = Hash.new { |h, k| h[k] = [] }
  paths[start_node] = [[start_node]]

  until q.empty?
    cur = q.pop
    pos, cur_dir = cur

    if pos == target
      unique_tiles = paths[cur].flat_map { |path| path.map(&:first) }.uniq

      return [dist[cur], unique_tiles.size]
    end

    x, y = pos

    DIRS.map do |new_dir|
      dx, dy = new_dir

      nx = x + dx
      ny = y + dy

      next if grid[ny][nx] == '#'

      neighbour = [[nx, ny], new_dir]

      # switching directions is a costly affair for a reindeer
      cost = new_dir == cur_dir ? 1 : 1001

      alt = dist[cur] + cost

      if alt < dist[neighbour]
        dist[neighbour] = alt
        q.push(neighbour, alt)
        paths[neighbour] = paths[cur].map { |path| path + [neighbour] }
      elsif alt == dist[neighbour]
        paths[neighbour] += paths[cur].map { |path| path + [neighbour] }
      end
    end
  end
end

score, num_tiles = dijkstra(grid, start_position, end_position)

# PART I
p score

# PART II
p num_tiles

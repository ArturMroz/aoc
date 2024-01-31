# typed: true

# https://adventofcode.com/2023/day/17

input = File.read('inputs/17.txt')

Grid   = input.split("\n").map { |row| row.chars.map(&:to_i) }
Width  = Grid[0].size - 1
Height = Grid.size - 1

require 'set'
require '../ds/priority_queue'

def get_pos(x, y, dir)
  case dir
  when :right
    [x + 1, y]
  when :left
    [x - 1, y]
  when :up
    [x, y - 1]
  when :down
    [x, y + 1]
  end
end

def get_neighbours(u, part2)
  (x, y), dir, steps = u

  limit      = part2 ? 10 : 3
  neighbours = []

  neighbours << [get_pos(x, y, dir), dir, steps + 1] if steps < limit

  if !part2 || (part2 && steps >= 4)
    case dir
    when :right, :left
      neighbours << [get_pos(x, y, :up), :up, 1]
      neighbours << [get_pos(x, y, :down), :down, 1]
    when :up, :down
      neighbours << [get_pos(x, y, :left), :left, 1]
      neighbours << [get_pos(x, y, :right), :right, 1]
    end
  end

  neighbours
end

def dijkstra(part2)
  q    = PriorityQueue.new
  dist = Hash.new(100_000)

  start  = [0, 0]
  target = [Width, Height]

  start_node1 = [start, :right, 1]
  start_node2 = [start, :down, 1]

  dist[start_node1] = 0
  dist[start_node2] = 0

  q.push(start_node1, 0)
  q.push(start_node2, 0)

  until q.empty?
    u   = q.pop
    pos = u.first

    return dist[u] if pos == target

    neighbours = get_neighbours(u, part2)

    neighbours.each do |v|
      vx, vy = v.first

      next unless vx.between?(0, Width) && vy.between?(0, Height)

      alt = dist[u] + Grid[vy][vx]

      if alt < dist[v]
        dist[v] = alt
        q.push(v, alt)
      end
    end
  end
end

# PART I

p dijkstra(false)

# PART II

p dijkstra(true)

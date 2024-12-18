# https://adventofcode.com/2024/day/18

points = File.read('inputs/18.txt').split("\n")
  .map { |line| line.split(',').map(&:to_i) }

DIRS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

def bfs(grid, start, target)
  q    = [start]
  seen = Set.new([start])
  prev = {}

  until q.empty?
    nq = []

    q.each do |x, y|
      DIRS.map { |dx, dy| [x + dx, y + dy] }.each do |neighbour|
        nx, ny = neighbour

        next unless y >= YMIN && y <= YMAX && x >= XMIN && x <= XMAX
        next if seen.include?([nx, ny])
        next if grid[[nx, ny]]

        seen << neighbour

        prev[neighbour] = [x, y]

        if neighbour == target
          path = []
          while target
            path << target
            target = prev[target]
          end

          return path.to_set
        end

        nq << neighbour
      end
    end

    q = nq
  end
end

# PART I

first_chunk_size = 1024

grid = {}
points.first(first_chunk_size).each do |x, y|
  grid[[x, y]] = true
end

XMIN, XMAX = points.map(&:first).minmax
YMIN, YMAX = points.map(&:last).minmax

start  = [XMIN, YMIN]
target = [XMAX, YMAX]

path = bfs(grid, start, target)

p path.size - 1

# PART II

points[first_chunk_size..].each do |pos|
  grid[pos] = true

  # don't bother if new block didn't land on the current path
  next unless path.include?(pos)

  path = bfs(grid, start, target)

  if path.nil?
    puts "no exit at #{pos.join(',')}"
    break
  end
end

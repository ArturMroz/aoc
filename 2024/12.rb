# https://adventofcode.com/2024/day/12

GRID = File.read('inputs/12.txt').split("\n").map(&:chars)

OFFSETS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

$seen = Set.new

def in_bounds?(x, y)
  y >= 0 && y < GRID.size && x >= 0 && x < GRID[0].size
end

def flood_fill(start_pos)
  q     = [start_pos]
  plots = []

  until q.empty?
    pos = q.pop

    next if $seen.include?(pos)

    $seen << pos
    plots << pos

    x, y = pos

    OFFSETS.map { |dx, dy| [x + dx, y + dy] }.each do |nx, ny|
      next unless in_bounds?(nx, ny)
      next unless GRID[y][x] == GRID[ny][nx]

      q << [nx, ny]
    end
  end

  plots.to_set
end

def find_num_fences(plots)
  plots.sum do |x, y|
    # fences exsist where given point doesn't have a neighbour
    fences = OFFSETS
      .map { |dx, dy| [x + dx, y + dy] }
      .reject { |nx, ny| plots.include?([nx, ny]) }

    fences.size
  end
end

def find_num_sides(plots)
  points = Hash.new { |h, k| h[k] = [] }

  plots.each do |x, y|
    # turn each plot point into a square (so we get 4 surrounding points from 1 plot point)
    [[-0.5, -0.5], [0.5, -0.5], [-0.5, 0.5], [0.5, 0.5]].each do |dx, dy|
      points[[x + dx, y + dy]] << [x, y]
    end
  end

  # if surrounding points overlap an odd number of times, we found a corner
  num_corners = points.filter { |_, vals| vals.size == 1 || vals.size == 3 }.size

  num_inner_overlapped_corners = 0
  # if a point overplaps 2 times, check if the plots are on a diagonal
  points.values.filter { |vals| vals.size == 2 }.each do |(x1, y1), (x2, y2)|
    # plots are on the diagonal, so we need to count 2 more corners
    num_inner_overlapped_corners += 2 if x1 != x2 && y1 != y2
  end

  # number of corners == number of sides
  num_corners + num_inner_overlapped_corners
end

regions = []

GRID.each_index do |y|
  GRID[y].each_index do |x|
    next if $seen.include?([x, y])

    region = flood_fill([x, y])
    regions << region
  end
end

total_price_p1 = regions.sum { |plots| plots.size * find_num_fences(plots) }
total_price_p2 = regions.sum { |plots| plots.size * find_num_sides(plots)  }

p total_price_p1
p total_price_p2

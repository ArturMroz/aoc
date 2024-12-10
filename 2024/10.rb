# https://adventofcode.com/2024/day/10

GRID = File.read('inputs/10.txt').split("\n")
  .map { |line| line.chars.map(&:to_i) }

OFFSETS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

start_positions = []
GRID.each_with_index do |row, y|
  row.each_with_index do |char, x|
    start_positions << [x, y] if char == 0
  end
end

def in_bounds?(x, y)
  y >= 0 && y < GRID.size && x >= 0 && x < GRID[0].size
end

def get_trail_score_and_rating(start_pos)
  q     = [start_pos]
  nines = []

  until q.empty?
    pos  = q.pop
    x, y = pos

    OFFSETS.map { |dx, dy| [x + dx, y + dy] }.each do |nx, ny|
      next unless in_bounds?(nx, ny)
      next unless GRID[y][x] == GRID[ny][nx] - 1

      if GRID[ny][nx] == 9
        nines << [nx, ny]
      else
        q << [nx, ny]
      end
    end
  end

  score  = nines.uniq.size
  rating = nines.size

  [score, rating]
end

total_score  = 0
total_rating = 0

start_positions.each do |pos|
  score, rating = get_trail_score_and_rating(pos)

  total_score  += score
  total_rating += rating
end

p total_score
p total_rating

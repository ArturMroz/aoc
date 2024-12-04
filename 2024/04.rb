# https://adventofcode.com/2024/day/4

grid = File.read('inputs/04.txt').split("\n").map(&:chars)

width  = grid[0].size
height = grid.size

# PART I

hits = 0

dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, -1], [1, -1], [-1, 1]]

grid.each_index do |y|
  grid[y].each_index do |x|
    next unless grid[y][x] == 'X'

    dirs.each do |dy, dx|
      next unless (0...height).cover?(y + (3 * dy)) && (0...width).cover?(x + (3 * dx))

      word = (0..3).map { |i| grid[y + (i * dy)][x + (i * dx)] }

      hits += 1 if word == 'XMAS'.chars
    end
  end
end

p hits

# PART II

def check(word)
  %w[MAS SAM].include?(word.join)
end

hits = 0

(0...height - 2).each do |y|
  (0...width - 2).each do |x|
    word1 = [grid[y][x], grid[y + 1][x + 1], grid[y + 2][x + 2]]
    word2 = [grid[y + 2][x], grid[y + 1][x + 1], grid[y][x + 2]]

    hits += 1 if check(word1) && check(word2)
  end
end

p hits

# https://adventofcode.com/2024/day/8

Grid = File.read('inputs/08.txt').split("\n")

antennas = Hash.new { |h, k| h[k] = [] }

Grid.each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    antennas[char] << [x, y] if char != '.'
  end
end

def in_bounds?(x, y)
  y >= 0 && y < Grid.size && x >= 0 && x < Grid[0].size
end

def solve_p1(antennas)
  antinodes = Set.new

  antennas.each do |_, locations|
    locations.combination(2) do |(x1, y1), (x2, y2)|
      dx = x2 - x1
      dy = y2 - y1

      x1 -= dx
      y1 -= dy

      x2 += dx
      y2 += dy

      antinodes << [x1, y1] if in_bounds?(x1, y1)
      antinodes << [x2, y2] if in_bounds?(x2, y2)
    end
  end

  antinodes.size
end

def solve_p2(antennas)
  antinodes = Set.new

  antennas.each do |_, locations|
    locations.combination(2) do |(x1, y1), (x2, y2)|
      dx = x2 - x1
      dy = y2 - y1

      while in_bounds?(x1, y1)
        antinodes << [x1, y1]
        x1 -= dx
        y1 -= dy
      end

      while in_bounds?(x2, y2)
        antinodes << [x2, y2]
        x2 += dx
        y2 += dy
      end
    end
  end

  antinodes.size
end

p solve_p1(antennas)
p solve_p2(antennas)

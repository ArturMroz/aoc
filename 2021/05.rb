# https://adventofcode.com/2021/day/5

input = File.read('inputs/05.txt').split("\n")

points = input.map { |line| line.scan(/\d+/).map(&:to_i) }
grid   = Hash.new 0

# PART I

points.each do |x1, y1, x2, y2|
  if x1 == x2
    y1, y2 = [y1, y2].sort
    (y1..y2).each { |y| grid[[x1, y]] += 1 }
  elsif y1 == y2
    x1, x2 = [x1, x2].sort
    (x1..x2).each { |x| grid[[x, y1]] += 1 }
  end
end

num_overlaps = grid.values.count { |v| v > 1 }

p num_overlaps

# PART II

points.each do |x1, y1, x2, y2|
  next if x1 == x2 || y1 == y2

  len = (x1 - x2).abs

  dx = x1 < x2 ? 1 : -1
  dy = y1 < y2 ? 1 : -1

  (0..len).each do |i|
    x = x1 + (i * dx)
    y = y1 + (i * dy)

    grid[[x, y]] += 1
  end
end

num_overlaps = grid.values.count { |v| v > 1 }

p num_overlaps

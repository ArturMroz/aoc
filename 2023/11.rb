# https://adventofcode.com/2023/day/11

input = File.read('inputs/11.txt').split("\n").map(&:chars)

galaxies = []
input.each_with_index do |row, y|
  row.each_with_index do |col, x|
    galaxies << [x, y] if col == '#'
  end
end

pairs = galaxies.combination(2).to_a

empty_rows = input.map.with_index { |row, y| row.all?('.') ? y : nil }.compact
empty_cols = input.transpose.map.with_index { |col, x| col.all?('.') ? x : nil }.compact

def get_sum_of_distances(pairs, empty_rows, empty_cols, multiplier)
  pairs.sum do |g1, g2|
    distance = (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs

    xmin, xmax = [g1[0], g2[0]].sort
    empty_cols_size = empty_cols.count { |x| x.between?(xmin, xmax) } * multiplier

    ymin, ymax = [g1[1], g2[1]].sort
    empty_rows_size = empty_rows.count { |y| y.between?(ymin, ymax) } * multiplier

    distance + empty_cols_size + empty_rows_size
  end
end

# PART I

p get_sum_of_distances(pairs, empty_rows, empty_cols, 1)

# PART II

p get_sum_of_distances(pairs, empty_rows, empty_cols, 999_999)

# frozen_string_literal: true

# https://adventofcode.com/2021/day/13

cords, folds = File.read('inputs/13.txt').split("\n\n")

page = cords.split("\n")
  .to_set { |line| line.split(',').map(&:to_i) }

folds = folds.split("\n")
  .map { |line| line.split.last.split('=') }
  .map { |dir, val| [dir, val.to_i] }

folds.each_with_index do |(dir, val), i|
  page = page.to_set do |x, y|
    if dir == 'y' && y > val
      new_y = val - (y - val)
      [x, new_y]
    elsif dir == 'x' && x > val
      new_x = val - (x - val)
      [new_x, y]
    else
      [x, y]
    end
  end

  p page.size if i == 0 # part I
end

# PART II

max_x = page.map(&:first).max
max_y = page.map(&:last).max

(0..max_y).each do |y|
  (0..max_x).each do |x|
    if page.include?([x, y])
      print '#'
    else
      print '.'
    end
  end

  puts
end

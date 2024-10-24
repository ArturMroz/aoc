# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2022/day/18

input = File.read('inputs/18.txt').split("\n")

DROPLETS = input.to_set { |line| line.split(',').map(&:to_i) }.freeze

def sides(x, y, z)
  [[x - 1, y, z], [x + 1, y, z], [x, y - 1, z], [x, y + 1, z], [x, y, z - 1], [x, y, z + 1]]
end

# PART I

p1_answer = DROPLETS.sum do |x, y, z|
  6 - (sides(x, y, z).to_set & DROPLETS).size
end

p p1_answer

# PART II

XRANGE, YRANGE, ZRANGE = DROPLETS.to_a.transpose.map(&:minmax).map { |a, b| a - 1..b + 1 }

def floodfill(start)
  q            = [start]
  seen         = Set.new
  num_surfaces = 0

  until q.empty?
    cur     = q.pop
    x, y, z = cur

    next unless XRANGE.include?(x) && YRANGE.include?(y) && ZRANGE.include?(z)

    if DROPLETS.include?(cur)
      num_surfaces += 1
      next
    end

    next if seen.include?(cur)

    seen << cur

    q += sides(x, y, z)
  end

  num_surfaces
end

p floodfill([XRANGE.min, YRANGE.min, ZRANGE.min])

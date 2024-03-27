# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2023/day/22

input = File.read('inputs/22.txt').split("\n")

# PART I

bricks = input.map do |line|
  x1, y1, z1, x2, y2, z2 = line.scan(/\d+/).map(&:to_i)
  [[x1, y1, z1], [x2, y2, z2]]
end

sorted_bricks = bricks.sort_by { |end1, _| end1[2] } # sort by lower z
fallen_bricks = []
sustained_by  = {}

sorted_bricks.each do |brick|
  (x1, y1, z1), (x2, y2, z2) = brick

  z_cur = z1

  bricks_on_lower_level = []

  while z_cur > 1
    bricks_on_lower_level = fallen_bricks.filter do |(lx1, ly1, _), (lx2, ly2, lz2)|
      lz2 == z_cur - 1 && x1 <= lx2 && x2 >= lx1 && y1 <= ly2 && y2 >= ly1
    end

    break if bricks_on_lower_level.any?

    z_cur -= 1
  end

  fell_by = z1 - z_cur
  new_pos = [[x1, y1, z1 - fell_by], [x2, y2, z2 - fell_by]]

  sustained_by[new_pos] = bricks_on_lower_level

  fallen_bricks << new_pos
end

nonremovables = sustained_by.values.filter { |v| v.size == 1 }.flatten(1).uniq

p1_answer = fallen_bricks.size - nonremovables.size

p p1_answer

# PART II

require 'set'

sustains = Hash.new { [] }

sustained_by.each do |k, vs|
  vs.each { |v| sustains[v] <<= k }
end

def count_disintegrated_chain(brick, sustained_by, sustains)
  q             = [brick]
  desintegrated = Set.new

  until q.empty?
    cur = q.shift

    desintegrated << cur

    sustains[cur].each do |brick_on_higher_level|
      q << brick_on_higher_level if sustained_by[brick_on_higher_level].all? { |b| desintegrated.include?(b) }
    end
  end

  desintegrated.size - 1
end

p2_answer = nonremovables.sum do |brick|
  count_disintegrated_chain(brick, sustained_by, sustains)
end

p p2_answer

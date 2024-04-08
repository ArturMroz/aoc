# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2023/day/24

input = File.read('inputs/24.txt').split("\n")

hailstones = input.map { |line| line.scan(/-?\d+/).map(&:to_i) }

# PART I

range = 200_000_000_000_000..400_000_000_000_000

p1_answer = hailstones.combination(2).count do |a, b|
  px1, py1, _, vx1, vy1, = a
  px2, py2, _, vx2, vy2, = b

  det = ((vx2 * vy1) - (vy2 * vx1)).to_f

  # bail if rays are parallel
  next if det.zero?

  dx = px2 - px1
  dy = py2 - py1

  time_a = ((dy * vx2) - (dx * vy2)) / det
  time_b = ((dy * vx1) - (dx * vy1)) / det

  # bail if paths crossed in the past
  next if time_a < 0 || time_b < 0

  x = px1 + (time_a * vx1)
  y = py1 + (time_a * vy1)

  range.include?(x) && range.include?(y)
end

p p1_answer

# PART II

require 'matrix'

Hailstone = Struct.new(:pos, :vel)

def intersection_time(a, b)
  plane_normal = a.pos.cross(a.pos + a.vel)

  denominator = b.vel.dot(plane_normal)

  raise 'line and plane are parallel, pick different hailstones' if denominator == 0

  -b.pos.dot(plane_normal) / denominator
end

# Consider hailstone R as a frame of reference, making its position and velocity zero while
# remaining at the origin. All trajectories, including the rock's, become lines relative to R.
# Since the rock must intersect with all hailstones, it passes through the origin and the lines of
# every hailstone.
# Take an arbitrary hailstone A and define a plane through the origin and any two points on its
# line. The rock must travel along this plane to hit A. Similarly, for another hailstone B to
# intersect with the rock, its line must intersect the plane formed by the origin and A, providing
# the intersection time of the rock with B.
reference, a, b = hailstones
  .take(3)
  .map { |h| Hailstone.new(Vector[*h.first(3)], Vector[*h.last(3)]) }

ra = Hailstone.new(a.pos - reference.pos, a.vel - reference.vel)
rb = Hailstone.new(b.pos - reference.pos, b.vel - reference.vel)

time_a = intersection_time(rb, ra)
time_b = intersection_time(ra, rb)

rock_pos_at_a = a.pos + (a.vel * time_a)
rock_pos_at_b = b.pos + (b.vel * time_b)

delta_time = time_b - time_a
delta_pos  = rock_pos_at_b - rock_pos_at_a

rock_vel = delta_pos / delta_time
rock_pos = rock_pos_at_a - (rock_vel * time_a)

p2_answer = rock_pos.sum

p p2_answer

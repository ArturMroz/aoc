# frozen_string_literal: true

# https://adventofcode.com/2021/day/17

input = File.read('inputs/17.txt')

x_min, x_max, y_min, y_max = input.scan(/-?\d+/).map(&:to_i)

XRANGE = (x_min..x_max)
YRANGE = (y_min..y_max)

def shoot(vx, vy)
  x = 0
  y = 0
  max_pos = -100_000

  loop do
    x += vx
    y += vy

    vx -= vx <=> 0 # reduce vx by 1 towards 0
    vy -= 1

    max_pos = [max_pos, y].max

    # bullseye
    return max_pos if XRANGE.include?(x) && YRANGE.include?(y)

    # overshoot
    return nil if y < YRANGE.begin || x > XRANGE.end
  end
end

vx_min = 0
vx_max = x_max
vy_min = y_min
vy_max = y_min.abs

max_height  = 0
num_correct = 0

(vx_min..vx_max).each do |vx|
  (vy_min..vy_max).each do |vy|
    height = shoot(vx, vy)
    next unless height

    max_height = [max_height, height].max
    num_correct += 1
  end
end

# PART I
p max_height

# PART II
p num_correct

# https://adventofcode.com/2024/day/14

input = File.read('inputs/14.txt').split("\n")

robots = input.map { |line| line.scan(/-?\d+/).map(&:to_i) }

starting_positions = robots.map { |x, y, _, _| [x, y] }
velocities         = robots.map { |_, _, vx, vy| [vx, vy] }

WIDTH  = 101
HEIGHT = 103

def get_positions_at_step(positions, velocities, step)
  positions.zip(velocities).map do |(x, y), (vx, vy)|
    [
      (x + (step * vx)) % WIDTH,
      (y + (step * vy)) % HEIGHT
    ]
  end
end

def print_robots(starting_positions, velocities, step)
  points = get_positions_at_step(starting_positions, velocities, step)
  tally  = points.tally

  (0...HEIGHT).each do |y|
    (0...WIDTH).each do |x|
      print tally[[x, y]] || '.'
    end
    puts
  end
end

# PART I

step = 100

positions = get_positions_at_step(starting_positions, velocities, step)

xcenter = (WIDTH / 2) + 1
ycenter = (HEIGHT / 2) + 1

quadrants = Hash.new 0

positions.each do |x, y|
  next if x == xcenter - 1 || y == ycenter - 1

  quadrants[[x / xcenter, y / ycenter]] += 1
end

safety_factor = quadrants.values.reduce(:*)

p safety_factor

# PART II

positions = starting_positions

history     = Set.new
entropy_log = {}

(1..).each do |step|
  positions_snapshot = positions.hash
  break if history.include?(positions_snapshot) # bail if we detected a cycle

  history << positions_snapshot

  positions = get_positions_at_step(starting_positions, velocities, step)

  num_unique_xs = positions.map(&:first).uniq.size
  num_unique_ys = positions.map(&:last).uniq.size

  entropy_log[[num_unique_xs, num_unique_ys]] = step
end

# robot positions with the smallest entropy contain a pattern (a picture of a xmas tree)
_, step = entropy_log.to_a.min_by(&:first)

p step

print_robots(starting_positions, velocities, step)

# typed: true

# https://adventofcode.com/2023/day/18

def solve(part2)
  input    = File.readlines('inputs/18.txt')
  points   = [[0, 0]]
  boundary = 0

  input.each do |line|
    dir, len, color = line.split

    len = len.to_i

    if part2
      len     = color[2..-3].to_i(16)
      dir_idx = color[-2].to_i
      dir     = %w[R D L U][dir_idx]
    end

    boundary += len

    x, y = points.last

    case dir
    when 'R'
      points << [x + len, y]
    when 'L'
      points << [x - len, y]
    when 'U'
      points << [x, y - len]
    when 'D'
      points << [x, y + len]
    end
  end

  area     = shoelace_formula(points)
  interior = pick_theorem(area, boundary)

  boundary + interior
end

def shoelace_formula(path)
  total = path
    .each_cons(2)
    .sum { |(x1, y1), (x2, y2)| (x1 * y2) - (x2 * y1) }

  total.abs / 2
end

def pick_theorem(area, num_boundary_points)
  area - (num_boundary_points / 2) + 1
end

# PART I

p solve(false)

# PART II

p solve(true)

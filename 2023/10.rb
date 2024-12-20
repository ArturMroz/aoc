# https://adventofcode.com/2023/day/10

input = File.read('inputs/10.txt').split("\n")

def find_start(input)
  input.each_with_index do |row, y|
    row.chars.each_with_index do |col, x|
      return [x, y] if col == 'S'
    end
  end
end

def find_path(start, input)
  next_pos = [start[0], start[1] + 1] # move 1 tile down from the start
  path     = [start]
  pos      = next_pos

  loop do
    x, y = pos
    cur  = input[y][x]

    prev_x, prev_y = path.last

    path << pos

    case cur
    when '|'
      y = prev_y < y ? y + 1 : y - 1
    when '-'
      x = prev_x < x ? x + 1 : x - 1
    when 'L'
      if prev_x == x
        x += 1
      else
        y -= 1
      end
    when 'J'
      if prev_x == x
        x -= 1
      else
        y -= 1
      end
    when '7'
      if prev_x == x
        x -= 1
      else
        y += 1
      end
    when 'F'
      if prev_x == x
        x += 1
      else
        y += 1
      end
    when 'S'
      path.pop # remove last point as that's Start
      return path
    end

    pos = [x, y]
  end
end

start = find_start(input)
path  = find_path(start, input)

p path.size / 2

# PART II, using maths

def shoelace_formula(path)
  total = (path + [path.first]).each_cons(2).sum do |(x1, y1), (x2, y2)|
    (x1 * y2) - (x2 * y1)
  end

  total.abs / 2
end

def pick_theorem(area, num_boundary_points)
  area - (num_boundary_points / 2) + 1
end

area                = shoelace_formula(path)
num_interior_points = pick_theorem(area, path.size)

p num_interior_points

# PART II, using flood fill

require 'set'

def get_char_to_replace_start_with(first, last)
  first_x, first_y = first
  last_x, last_y   = last

  if first_x == last_x
    '|'
  elsif first_y == last_y
    '-'
  elsif first_x < last_x && first_y < last_y
    'L'
  elsif first_x < last_x && first_y > last_y
    'F'
  elsif first_x > last_x && first_y < last_y
    'J'
  elsif first_x > last_x && first_y > last_y
    '7'
  end
end

def double_grid_size(input, path)
  result      = []
  filler_char = '*'

  input.each_with_index do |row, y|
    new_row1 = []
    new_row2 = []

    row.chars.each_with_index do |col, x|
      col = '.' unless path.include?([x, y])

      new_char =
        if col =~ /[FL-]/ && input[y][x + 1] =~ /[J7-]/
          '-'
        else
          filler_char
        end

      new_row1.push(col, new_char)

      new_char =
        if col =~ /[F7|]/ && input[y + 1][x] =~ /[JL|]/
          '|'
        else
          filler_char
        end

      new_row2.push(new_char, filler_char)
    end

    result.push(new_row1, new_row2)
  end

  result
end

def find_point_inside_loop(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |_, x|
      return [x + 1, y] if row[x] == '|' && row[x + 1] == '*'
    end
  end
end

def flood_fill(starting_point, grid)
  q          = [starting_point]
  seen       = Set.new
  num_filled = 0

  until q.empty?
    x, y = q.pop

    next unless x.between?(0, grid[0].size) && y.between?(0, grid.size - 1)

    next if seen.include?([x, y])

    seen << [x, y]

    next if grid[y][x] != '*' && grid[y][x] != '.'

    num_filled += 1 if grid[y][x] == '.'

    q << [x, y + 1]
    q << [x, y - 1]
    q << [x + 1, y]
    q << [x - 1, y]
  end

  num_filled
end

input[start[1]][start[0]] = get_char_to_replace_start_with(path[1], path[-1])

thicc_grid = double_grid_size(input, path.to_set)

point_inside_loop = find_point_inside_loop(thicc_grid)

p flood_fill(point_inside_loop, thicc_grid)

# https://adventofcode.com/2024/day/15

grid_og, moves = File.read('inputs/15.txt').split("\n\n")

grid  = grid_og.split("\n").map(&:chars)
moves = moves.split("\n").join

DIRS = {
  '<' => [-1, 0],
  '>' => [1, 0],
  '^' => [0, -1],
  'v' => [0, 1]
}.freeze

def gps_sum(grid, target)
  grid.each_with_index.sum do |row, y|
    row.each_with_index.sum do |char, x|
      char == target ? (100 * y) + x : 0
    end
  end
end

def debug_print(grid, pos)
  grid.each_with_index do |row, y|
    row.each_with_index do |char, x|
      print pos == [x, y] ? '@' : char
    end
    puts
  end
end

# PART I

start_position = nil
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    if char == '@'
      start_position = [x, y]
      grid[y][x]     = '.'
    end
  end
end

x, y = start_position

moves.chars.each do |move|
  dx, dy = DIRS[move]

  nx = x + dx
  ny = y + dy

  case grid[ny][nx]
  when '#'
    next

  when '.'
    x = nx
    y = ny

  when 'O'
    bx = nx
    by = ny

    while grid[by][bx] == 'O'
      bx += dx
      by += dy
    end

    # bail if there's no space to push the boxes
    next if grid[by][bx] != '.'

    grid[ny][nx] = '.'
    grid[by][bx] = 'O'

    x = nx
    y = ny
  end
end

p gps_sum(grid, 'O')

# PART II

wide_map = {
  '#' => '##',
  'O' => '[]',
  '.' => '..',
  '@' => '..'
}.freeze

grid = grid_og.lines.map do |row|
  row.chars.map { |char| wide_map[char] }.join.chars
end

start_position = [start_position[0] * 2, start_position[1]]

x, y = start_position

moves.chars.each do |move|
  dx, dy = DIRS[move]

  nx = x + dx
  ny = y + dy

  case [grid[ny][nx], move]
  in ['#', _]
    next

  in ['.', _]
    x = nx
    y = ny

  in ['[', '>'] | [']', '<']
    bx = nx

    # check every second tile
    bx += 2 * dx while grid[ny][bx] == grid[ny][nx]

    next if grid[ny][bx] != '.'

    bx.step(nx, -dx) do |xx|
      grid[ny][xx] = grid[ny][xx - dx]
    end

    x = nx
    y = ny

  in ['[' | ']', 'v' | '^']
    boxes_to_push = Set.new
    q             = [[nx, ny]]

    q << if grid[ny][nx] == '['
           [nx + 1, ny]
         else
           [nx - 1, ny]
         end

    hit_a_wall = false

    while (bx, by = q.pop)
      next if boxes_to_push.include?([bx, by])

      boxes_to_push << [bx, by]

      case grid[by + dy][bx]
      when ']'
        q << [bx, by + dy]
        q << [bx - 1, by + dy]
      when '['
        q << [bx, by + dy]
        q << [bx + 1, by + dy]
      when '#'
        hit_a_wall = true
        break
      end
    end

    next if hit_a_wall

    # sort points so we won't overwrite changes
    sorted = boxes_to_push.sort_by { |_, y| -y * dy }

    sorted.each do |x, y|
      grid[y + dy][x] = grid[y][x]
      grid[y][x]      = '.'
    end

    x = nx
    y = ny
  end
end

p gps_sum(grid, '[')

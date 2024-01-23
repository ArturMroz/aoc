# https://adventofcode.com/2023/day/14

input = File.read('inputs/14.txt')

def find_first_free_spot_north(grid, x, y)
  (y - 1).downto(0) do |i|
    return i + 1 if grid[i][x] != '.'
  end

  0
end

def tilt_north(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |ch, x|
      next unless ch == 'O'

      y_new = find_first_free_spot_north(grid, x, y)

      next if y == y_new

      grid[y_new][x] = 'O'
      grid[y][x]     = '.'
    end
  end
end

def rotate_clockwise(grid)
  grid.transpose.map(&:reverse)
end

def get_total_load(grid)
  grid.each_with_index.sum do |row, y|
    num_round     = row.count('O')
    load_per_rock = grid.size - y

    num_round * load_per_rock
  end
end

def solve_p1(input)
  grid = input.split("\n").map(&:chars)

  tilt_north(grid)
  get_total_load(grid)
end

def solve_p2(input)
  grid = input.split("\n").map(&:chars)

  num_cycles = 1_000_000_000
  cur_cycle  = 1

  history = {}

  while cur_cycle <= num_cycles
    4.times do
      tilt_north(grid)
      grid = rotate_clockwise(grid)
    end

    if history.key?(grid.hash)
      last_seen_at    = history[grid.hash]
      repeat_interval = cur_cycle - last_seen_at
      cycles_to_skip  = (num_cycles - cur_cycle) / repeat_interval * repeat_interval

      cur_cycle += cycles_to_skip
    else
      history[grid.hash] = cur_cycle
    end

    cur_cycle += 1
  end

  get_total_load(grid)
end

p solve_p1(input)

p solve_p2(input)

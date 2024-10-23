# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2022/day/17

Jets = File.read('inputs/17.txt').chars

Rocks = [
  [[-1, 0], [0, 0], [1, 0], [2, 0]],         # -
  [[0, 0], [-1, 1], [0, 1], [1, 1], [0, 2]], # +
  [[1, 1], [-1, 0], [0, 0], [1, 0], [1, 2]], # L
  [[-1, 0], [-1, 1], [-1, 2], [-1, 3]],      # |
  [[-1, 0], [0, 0], [-1, 1], [0, 1]]         # □
].freeze

def move_right(cave, rock)
  return if rock.any? { |x, y| cave[y][x + 1] || x + 1 > 6 }

  rock.each { |pos| pos[0] += 1 }
end

def move_left(cave, rock)
  return if rock.any? { |x, y| cave[y][x - 1] || x - 1 < 0 }

  rock.each { |pos| pos[0] -= 1 }
end

def move_down(cave, rock)
  return false if rock.any? { |x, y| cave[y - 1][x] || y - 1 < 0 }

  rock.each { |pos| pos[1] -= 1 }
end

def get_tower_height(lim)
  cave = Hash.new { |h, k| h[k] = Hash.new(false) }

  height = 0
  rock_i = 0
  jet_i  = 0

  cache = {}

  while rock_i < lim
    rock = Rocks[rock_i % Rocks.size].map { |x, y| [x + 3, y + height + 3] }
    rock_i += 1

    loop do
      if Jets[jet_i % Jets.size] == '<'
        move_left(cave, rock)
      else
        move_right(cave, rock)
      end

      jet_i += 1

      next if move_down(cave, rock)

      rock.each { |x, y| cave[y][x] = true }

      height = [rock.map(&:last).max + 1, height].max

      break
    end

    cave_top_hash = [rock_i % Rocks.size, jet_i % Jets.size, cave.values.last(20)].hash

    if cache.key?(cave_top_hash)
      # deja vu: we've got a cycle on our hands and can calculate final result based on current knowledge

      rock_i_at_first_cycle_start, height_at_first_cycle_start = cache[cave_top_hash]

      cycle_len  = rock_i - rock_i_at_first_cycle_start
      num_cycles = lim / cycle_len

      rock_i_at_last_cycle_end = rock_i + ((num_cycles - 1) * cycle_len)
      rock_i_at_midcycle       = lim - rock_i_at_last_cycle_end + rock_i_at_first_cycle_start

      height_per_cycle       = height - height_at_first_cycle_start
      total_height_in_cycles = num_cycles * height_per_cycle

      height_at_midcycle = cache.values.find { |i, _height| i == rock_i_at_midcycle }.last

      final_height = total_height_in_cycles + height_at_midcycle

      return final_height
    else
      cache[cave_top_hash] = [rock_i, height]
    end
  end

  height
end

# PART I

p get_tower_height(2022)

# PART II

p get_tower_height(1_000_000_000_000)

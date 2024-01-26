# https://adventofcode.com/2023/day/16

input = File.read('inputs/16.txt')

Grid   = input.split("\n").map(&:chars)
Width  = Grid[0].size - 1
Height = Grid.size - 1

require 'set'

def energize(start)
  beams_to_trace  = [start]
  seen_beams      = Set.new
  energized_tiles = []

  until beams_to_trace.empty?
    beam = beams_to_trace.pop

    next if seen_beams.include?(beam)

    seen_beams << beam

    x, y, dir = beam

    loop do
      break unless x.between?(0, Width) && y.between?(0, Height)

      energized_tiles << [x, y]

      case Grid[y][x]
      when '.'
        case dir
        when :down
          y += 1
        when :up
          y -= 1
        when :right
          x += 1
        when :left
          x -= 1
        end

      when '|'
        case dir
        when :down
          y += 1
        when :up
          y -= 1
        when :left, :right
          beams_to_trace << [x, y - 1, :up]
          beams_to_trace << [x, y + 1, :down]
          break
        end

      when '-'
        case dir
        when :right
          x += 1
        when :left
          x -= 1
        when :up, :down
          beams_to_trace << [x - 1, y, :left]
          beams_to_trace << [x + 1, y, :right]
          break
        end

      when '/'
        case dir
        when :down
          dir = :left
          x -= 1
        when :up
          dir = :right
          x += 1
        when :right
          dir = :up
          y -= 1
        when :left
          dir = :down
          y += 1
        end

      when '\\'
        case dir
        when :down
          dir = :right
          x += 1
        when :up
          dir = :left
          x -= 1
        when :right
          dir = :down
          y += 1
        when :left
          dir = :up
          y -= 1
        end
      end
    end
  end

  energized_tiles.uniq.size
end

# PART I

start = [0, 0, :right]
p energize(start)

# PART II

max_energy = 0

(0..Width).each do |x|
  max_energy = [max_energy, energize([x, 0, :down]), energize([x, Height, :up])].max
end

(0..Height).each do |y|
  max_energy = [max_energy, energize([0, y, :right]), energize([Width, y, :left])].max
end

p max_energy

# https://adventofcode.com/2022/day/15

require 'set'

sensors       = Hash.new
beacons_at_ty = Set.new

ty = 2_000_000

File.read('inputs/15.txt').split("\n").each do |line|
  sx, sy, bx, by = line.scan(/-?\d+/).map(&:to_i)

  distance = (sx - bx).abs + (sy - by).abs
  sensors[[sx, sy]] = distance

  beacons_at_ty << bx if by == ty
end

# PART I

seen = []

sensors.each do |(sx, sy), d|
  next if sy + d < ty || sy - d > ty

  dx = 0
  duh = (sy - ty).abs - d
  loop do
    # (sx - (sx - dx)).abs + (sy - ty).abs <= d
    # dx + (sy - ty).abs <= d
    # (sy - ty).abs <= d - dx
    # duh <= d - dx
    if duh <= -dx
      seen << sx - dx
      seen << sx + dx
      dx += 1
    else
      break
    end
  end
end

p seen.uniq.size - beacons_at_ty.size


# PART II

def merge_ranges(ranges, y)
  ranges.size.times do |i|
    (i+1...ranges.size).each do |j|
      l1, r1 = ranges[i]
      l2, r2 = ranges[j]

      ranges_overlap = l1 <= r2+1 && l2 <= r1+1
      if ranges_overlap
        ranges[j] = [[l1, l2].min, [r1, r2].max]
        break
      elsif j == ranges.size-1
        x = l1 > r2 ? l1-1 : l2-1
        freq = x*4_000_000 + y 
        p "found a hole #{l1}-#{r1} & #{l2}-#{r2} at #{y}, tuning frequency = #{freq}"
        exit
      end
    end
  end
end

lim = 4_000_000
(0..lim).each do |y|
  ranges = []
  sensors.each do |(sx, sy), d|
    next if (sy - y).abs > d

    peak   = sy > y ? sy - d : sy + d
    height = (y - peak).abs
    left   = [sx - height, 0].max
    right  = [sx + height, lim].min

    ranges << [left, right]
  end

  merge_ranges(ranges, y)
end
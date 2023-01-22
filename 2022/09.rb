# https://adventofcode.com/2022/day/9

require 'set'

def signum(x) = x <=> 0

# rope = Array.new(2) { [0, 0] } # part I
rope = Array.new(10) { [0, 0] }  # part II

seen = Set.new

File.read('inputs/09.txt').split("\n").each do |line|
  direction, num = line.split

  num.to_i.times do 
    case direction
    when 'L' then rope[0][0] -= 1
    when 'R' then rope[0][0] += 1
    when 'U' then rope[0][1] += 1
    when 'D' then rope[0][1] -= 1
    end

    rope.each_cons(2) do |prev, curr|
      dx = prev[0] - curr[0]
      dy = prev[1] - curr[1]

      if dx.abs > 1 || dy.abs > 1
         curr[0] += signum dx
         curr[1] += signum dy
      end
    end

    seen << rope.last.dup
  end
end

p seen.size

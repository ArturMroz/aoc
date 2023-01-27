# https://adventofcode.com/2022/day/14

cave = Hash.new { |h, k| h[k] = Hash.new(false) }
ymax = 0

File.read('inputs/14.txt').split("\n").each do |line|
  line
    .split(" -> ")
    .map { |point| point.split(",").map(&:to_i) }
    .each_cons(2) do |(x1, y1), (x2, y2)|
      if x1 == x2
        if y1 > y2 then y2, y1 = y1, y2 end
        (y1..y2).each { |y| cave[x1][y] = true }
      elsif y1 == y2
        if x1 > x2 then x2, x1 = x1, x2 end
        (x1..x2).each { |x| cave[x][y1] = true }
      end

      ymax = [ymax, y2].max
    end
end

# PART I

count        = 0
void_reached = false

until void_reached do
  grain = [500, 0]

  loop do
    if grain[1] > ymax
      void_reached = true
      break
    end

    if !cave[grain[0]][grain[1]+1]
      grain[1] += 1
      next
    end

    if !cave[grain[0]-1][grain[1]+1]
      grain[0] -= 1
      grain[1] += 1
      next
    end

    if !cave[grain[0]+1][grain[1]+1]
      grain[0] += 1
      grain[1] += 1
      next
    end

    cave[grain[0]][grain[1]] = true
    count += 1
    break
  end
end

p count

# PART II

(300..700).each do |i|
  cave[i][ymax+2] = true
end

is_full = false

until is_full do
  grain = [500, 0]

  loop do
    if !cave[grain[0]][grain[1]+1]
      grain[1] += 1
      next
    end

    if !cave[grain[0]-1][grain[1]+1]
      grain[0] -= 1
      grain[1] += 1
      next
    end

    if !cave[grain[0]+1][grain[1]+1]
      grain[0] += 1
      grain[1] += 1
      next
    end

    cave[grain[0]][grain[1]] = true
    count += 1

    if grain[1] == 0
      is_full = true
    end

    break
  end
end

p count

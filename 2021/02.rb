# https://adventofcode.com/2021/day/2

input = File.read('inputs/02.txt').split("\n")

# PART I

x = 0
y = 0

input.each do |line|
  case line.split
  in 'forward', xx
    x += xx.to_i
  in 'down', yy
    y += yy.to_i
  in 'up', yy
    y -= yy.to_i
  end
end

p x * y

# PART II

x   = 0
y   = 0
aim = 0

input.each do |line|
  case line.split
  in 'forward', xx
    x += xx.to_i
    y += aim * xx.to_i
  in 'down', a
    aim += a.to_i
  in 'up', a
    aim -= a.to_i
  end
end

p x * y

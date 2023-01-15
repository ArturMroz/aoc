# https://adventofcode.com/2022/day/5

drawing, moves = File.read('inputs/05.txt').split("\n\n")

stacks = Array.new(9) { [] }

drawing.lines.reverse.each do |line|
  line.chars.each_slice(4).with_index do |box, i|
    stacks[i] << box[1] if box[0] == '['
  end
end

moves.lines.each do |line|
  num, src, dst = line.scan(/\d+/).map(&:to_i)

  # part I
  # num.times { stacks[dst-1] << stacks[src-1].pop }

  # part II
  stacks[dst-1] += stacks[src-1].pop(num)
end

p stacks.map(&:last).join

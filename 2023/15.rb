# https://adventofcode.com/2023/day/15

input = File.read('inputs/15.txt')

def get_hash(str)
  result = 0

  str.chars.each do |ch|
    result += ch.ord
    result *= 17
    result %= 256
  end

  result
end

# PART I

total = input.split(',').sum { |code| get_hash(code) }

p total

# PART II

boxes = Array.new(256) { [] }

input.split(',').each do |code|
  label, op, focal = code.match(/([a-z]+)([-=])(\d)?/).captures

  box_id = get_hash(label)

  if op == '-'
    boxes[box_id].reject! { |b| b[0] == label }
  elsif op == '='
    idx = boxes[box_id].index { |b| b[0] == label }

    if idx
      boxes[box_id][idx] = [label, focal]
    else
      boxes[box_id] << [label, focal]
    end
  end
end

focusing_power = 0

boxes.each_with_index do |box, i|
  box.each_with_index do |lens, j|
    focusing_power += (i + 1) * (j + 1) * lens[1].to_i
  end
end

p focusing_power

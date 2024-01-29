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
  label, op, focal_len = code.match(/([a-z]+)([-=])(\d)?/).captures

  box_id = get_hash(label)

  if op == '-'
    boxes[box_id].reject! { |b| b[0] == label }
  elsif op == '='
    idx = boxes[box_id].index { |b| b[0] == label }

    if idx
      boxes[box_id][idx] = [label, focal_len]
    else
      boxes[box_id] << [label, focal_len]
    end
  end
end

focusing_power = 0

boxes.each.with_index(1) do |box, i|
  box.each.with_index(1) do |(_, focal_len), j|
    focusing_power += i * j * focal_len.to_i
  end
end

p focusing_power

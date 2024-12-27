# https://adventofcode.com/2024/day/25

input = File.read('inputs/25.txt').split("\n\n")

keys  = []
locks = []

input.each do |schema|
  lines  = schema.split("\n")
  result = [0] * 5

  lines[1..5].each_with_index do |row, y|
    row.chars.each_with_index do |ch, x|
      result[x] += 1 if ch == '#'
    end
  end

  is_key = lines[0] == '.....'
  if is_key
    keys << result
  else
    locks << result
  end
end

ans = keys.product(locks).count do |key, lock|
  key.zip(lock).all? { |a, b| a + b <= 5 }
end

p ans

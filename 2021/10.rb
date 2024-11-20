# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2021/day/10

input = File.read('inputs/10.txt').split("\n")

# PART I

pairs = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

points = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}

incorrect_chars = []
autocompleted   = []

input.each do |line|
  corrupted = false
  stack     = []

  line.chars.each do |char|
    if pairs.key?(char)
      stack << pairs[char]
    elsif stack.pop != char
      incorrect_chars << char
      corrupted = true
      break
    end
  end

  autocompleted << stack.reverse.join unless corrupted
end

score = incorrect_chars.sum { |ch| points[ch] }
p score

# PART II

points2 = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

scores = autocompleted.map do |line|
  line.chars.reduce(0) { |score, char| (score * 5) + points2[char] }
end

middle_score = scores.sort[scores.size / 2]
p middle_score

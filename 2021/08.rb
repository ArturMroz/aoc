# frozen_string_literal: true

# https://adventofcode.com/2021/day/8

input = File.read('inputs/08.txt').split("\n")

# PART I

sum = input.sum do |line|
  _, output_values = line.split('|')

  output_values.split.count { |w| [2, 3, 4, 7].include?(w.size) }
end

p sum

# PART II

DIGITS_MAP = {
  '0' => 'abcefg',
  '1' => 'cf',
  '2' => 'acdeg',
  '3' => 'acdfg',
  '4' => 'bcdf',
  '5' => 'abdfg',
  '6' => 'abdefg',
  '7' => 'acf',
  '8' => 'abcdefg',
  '9' => 'abcdfg'
}.invert.freeze

sum = 0

input.each do |line|
  digits, output_values = line.split('|').map(&:split)

  tally = digits.join.chars.tally

  segments_map = {}

  # direct mappings based on unique segment occurrences
  segments_map['b'] = tally.key(6)
  segments_map['e'] = tally.key(4)
  segments_map['f'] = tally.key(9)

  # find unique digits for further deduction
  digit1 = digits.find { |d| d.chars.size == 2 }.chars
  digit4 = digits.find { |d| d.chars.size == 4 }.chars
  digit7 = digits.find { |d| d.chars.size == 3 }.chars

  # deduce other segments
  segments_map['a'] = (digit7 - digit1).first
  segments_map['c'] = ((digit1 & digit7) - [segments_map['f']]).first
  segments_map['d'] = (digit4 - digit1 - [segments_map['b']]).first
  segments_map['g'] = ('abcdefg'.chars - segments_map.values).first

  # decode output value
  from = segments_map.values.join
  to   = segments_map.keys.join

  cur_num = output_values.map do |val|
    key = val.tr(from, to).chars.sort.join

    DIGITS_MAP[key]
  end

  sum += cur_num.join.to_i
end

p sum

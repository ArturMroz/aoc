# frozen_string_literal: true

# https://adventofcode.com/2022/day/14

polymer_og, rules = File.read('inputs/14.txt').split("\n\n")

rules = rules.split("\n").to_h { |line| line.split(' -> ') }

# PART I

polymer = polymer_og

10.times do
  new_polymer = polymer.chars.each_cons(2).map do |a, b|
    a + rules[a + b]
  end

  new_polymer << polymer[-1]
  polymer = new_polymer.join
end

freqs = polymer.chars.tally.values

p freqs.max - freqs.min

# PART II

pairs = polymer_og.chars.each_cons(2).map(&:join).tally

40.times do
  pairs = pairs.each_with_object(Hash.new(0)) do |(pair, count), new_pairs|
    insert = rules[pair]
    a, b   = pair.chars

    new_pairs[a + insert] += count
    new_pairs[insert + b] += count
  end
end

# count frequencies of the first letter in the pair as pairs overlap
freqs = pairs.each_with_object(Hash.new(0)) do |(pair, count), hash|
  hash[pair[0]] += count
end

# include the last letter of the polymer as it doesn't overlap
freqs[polymer[-1]] += 1

p freqs.values.max - freqs.values.min

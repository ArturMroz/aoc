# https://adventofcode.com/2023/day/4

input = File.read('inputs/04.txt').lines

total_score = 0
card_counts = Hash.new 0

input.each_with_index do |card, id|
  nums         = card.split(':')[1]
  winning, got = nums.split('|').map(&:split)
  score        = (winning & got).size

  total_score += 2**(score - 1) if score > 0

  card_counts[id] += 1

  (id + 1..id + score).each do |other_card_id|
    card_counts[other_card_id] += card_counts[id]
  end
end

# PART I

p total_score

# PART II

p card_counts.values.sum

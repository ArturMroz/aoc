# https://adventofcode.com/2023/day/6

input = File.read('inputs/07.txt').lines

PART2 = true

LABELS = if PART2
           %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze
         else
           %w[A K Q J T 9 8 7 6 5 4 3 2].freeze
         end

STRENGTHS = %i[
  five_of_a_kind
  four_of_a_kind
  full_house
  three_of_a_kind
  two_pair
  one_pair
  high_card
].freeze

def strength(hand)
  tally      = hand.tally
  num_jokers = (PART2 && tally['J']) || 0

  case tally.values.sort.reverse
  in [5]
    :five_of_a_kind
  in [4, 1]
    num_jokers > 0 ? :five_of_a_kind : :four_of_a_kind
  in [3, 2]
    num_jokers > 0 ? :five_of_a_kind : :full_house
  in [3, 1, 1]
    num_jokers > 0 ? :four_of_a_kind : :three_of_a_kind
  in [2, 2, 1]
    if num_jokers == 2
      :four_of_a_kind
    elsif num_jokers == 1
      :full_house
    else
      :two_pair
    end
  in [2, 1, 1, 1]
    num_jokers > 0 ? :three_of_a_kind : :one_pair
  in [1, 1, 1, 1, 1]
    num_jokers > 0 ? :one_pair : :high_card
  end
end

def compare_hands(hand1, hand2)
  str1 = STRENGTHS.index strength(hand1)
  str2 = STRENGTHS.index strength(hand2)

  return str1 <=> str2 if str1 != str2

  hand1.zip(hand2).each do |l1, l2|
    return LABELS.index(l1) <=> LABELS.index(l2) if l1 != l2
  end
end

result = input
  .map(&:split)
  .sort { |(h1, _), (h2, _)| -compare_hands(h1.chars, h2.chars) }
  .map { |_, bid| bid.to_i }
  .map.with_index(1) { |bid, i| bid * i }
  .sum

p result

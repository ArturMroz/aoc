# https://adventofcode.com/2023/day/4

input = File.read('inputs/04.txt').lines

# PART I

sum         = 0
num_winning = []

input.each do |card|
    nums         = card.split(":")[1]
    winning, got = nums.split("|").map { |n| n.scan /\d+/ }
    scored       = winning & got

    if scored.size > 0
        sum += 2 ** (scored.size - 1)
    end

    num_winning << scored.size
end

p sum


# PART II

total = Hash.new(0)

num_winning.each.with_index(1) do |num_win, i|
    total[i] += 1

    (i+1..i+num_win).each do |card_id|
        total[card_id] += 1 * total[i]
    end
end

p total.values.sum
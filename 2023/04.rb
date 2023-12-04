# https://adventofcode.com/2023/day/4

input = File.read('inputs/04.txt').lines

# PART I

sum = 0
num_winning = []

input.each do |card|
    nums         = card.split(":")[1]
    winning, got = nums.split("|").map { |n| n.scan /\d+/ }
    have         = winning & got

    if have.size > 0
        points = 2 ** (have.size - 1)
        sum += points
    end

    num_winning << have.size
end

p sum


# PART II

total = Hash.new(0)

num_winning.each.with_index(1) do |num_win, i|
    total[i] += 1

    total[i].times do
        (i+1..i+num_win).each do |card_id|
            total[card_id] += 1 
        end
    end
end

p total.values.sum
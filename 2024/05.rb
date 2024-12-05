# https://adventofcode.com/2024/day/5

rules, updates = File.read('inputs/05.txt').split("\n\n")

rules = rules.lines.map { |line| line.split('|').map(&:to_i) }

rules = rules.flatten.uniq.to_h do |page|
  pages_before = rules.filter { |_, nxt| nxt == page }.to_set(&:first)
  pages_after  = rules.filter { |prev, _| prev == page }.to_set(&:last)

  [page, [pages_before, pages_after]]
end

updates = updates.lines.map { |line| line.split(',').map(&:to_i) }

# PART I

def correct?(update, rules)
  update.each_with_index do |page, i|
    pages_before, pages_after = rules[page]

    return false if update[i + 1..].any? { |pg| pages_before.include?(pg) }
    return false if update[...i + 1].any? { |pg| pages_after.include?(pg) }
  end

  true
end

correct_updates = updates.filter { |update| correct?(update, rules) }

mids_sum = correct_updates.sum { |update| update[update.size / 2] }

p mids_sum

# PART II

incorrect_updates = updates - correct_updates

incorrect_updates.each do |update|
  update.sort! do |a, b|
    pages_before, _ = rules[a]

    pages_before.include?(b) ? 1 : -1
  end
end

mids_sum = incorrect_updates.sum { |update| update[update.size / 2] }

p mids_sum

# https://adventofcode.com/2024/day/19

patterns, designs = File.read('inputs/19.txt').split("\n\n")

patterns = patterns.split(', ')
designs  = designs.split("\n")

# PART I

def design_possible?(patterns, design)
  return true if design.empty?

  patterns.any? do |pat|
    design.start_with?(pat) && design_possible?(patterns, design[pat.size..])
  end
end

num_possible = designs.count { |design| design_possible?(patterns, design) }

p num_possible

# PART II

def count_combinations(patterns, design, cache)
  return 1 if design.empty?
  return cache[design] if cache.key?(design)

  sum = 0
  patterns.each do |pat|
    if design.start_with?(pat)
      sum += count_combinations(patterns, design[pat.size..], cache)
    end
  end

  cache[design] = sum
end

num_combinations = designs.sum { |design| count_combinations(patterns, design, {}) }

p num_combinations

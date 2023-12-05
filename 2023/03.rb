# https://adventofcode.com/2023/day/3

Grid  = File.read('inputs/03.txt').split("\n")
Stars = Hash.new { [] }

def within_bounds?(y, x)
    y.between?(0, Grid.size - 1) && x.between?(0, Grid[0].size - 1)
end

def symbol_adjacent?(sy, sx, num)
    (sy - 1..sy + 1).each do |y|
        (sx - 1..sx + num.size).each do |x|
            if within_bounds?(y, x) && Grid[y][x] =~ /[^\d.]/
                Stars[[x, y]] <<= num if Grid[y][x] == '*'
                return true
            end
        end
    end

    false
end

sum = 0

Grid.each_with_index do |line, y|
    matches_with_indices = []
    line.scan(/\d+/) do |match|
        matches_with_indices << [match, Regexp.last_match.begin(0)]
    end

    sum += matches_with_indices
        .filter { |num, idx| symbol_adjacent?(y, idx, num) }
        .sum { |num, _| num.to_i }
end

# PART I

p sum

# PART II

sum = Stars
    .values
    .filter { |v| v.size == 2 }
    .sum { |a, b| a.to_i * b.to_i }

p sum

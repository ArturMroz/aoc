# https://adventofcode.com/2023/day/3

Grid  = File.read('inputs/03.txt').split("\n")
Stars = Hash.new { [] }

def symbol_adjacent?(sy, sx, num)
  ymin = [sy-1, 0].max
  ymax = [sy+1, Grid.size-1].min
  xmin = [sx-1, 0].max
  xmax = [sx+num.size, Grid[0].size-1].min

  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      if Grid[y][x].match /[^\d.]/ 
        Stars[[x, y]] <<= num if Grid[y][x] == "*"
        return true
      end
    end
  end

  false
end

sum = 0

Grid.each_with_index do |line, y|
  matches_with_indices = []
  line.scan(/\d+/) { |match| matches_with_indices << [match, $~.begin(0)] }
    
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

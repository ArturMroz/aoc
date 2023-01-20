# https://adventofcode.com/2022/day/8

forest  = File.read('inputs/08.txt').split("\n").map(&:chars)
forest2 = forest.transpose

# PART I

visible_trees = 0

forest.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    if forest[i][...j].all? { |x| x < tree } ||
      forest[i][j+1..].all? { |x| x < tree } ||
      forest2[j][...i].all? { |x| x < tree } ||
      forest2[j][i+1..].all? { |x| x < tree }
        visible_trees += 1
    end
  end
end

p visible_trees

# PART II

def score(row, tree)
  result = row.index { |x| x >= tree }
  result ? result+1 : row.size
end

max_scenic_score = 0

forest.each_with_index do |row, i|
  row.each_with_index do |tree, j|
    left  = score(forest[i][...j].reverse, tree)
    right = score(forest[i][j+1..], tree)
    up    = score(forest2[j][...i].reverse, tree)
    down  = score(forest2[j][i+1..], tree)

    scenic_score     = left * right * up * down
    max_scenic_score = [max_scenic_score, scenic_score].max
  end
end

p max_scenic_score

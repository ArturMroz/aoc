# https://adventofcode.com/2022/day/2

input = File.read('inputs/02.txt').split("\n")

# PART I

score = {
  'A X' => 3 + 1, # draw by rock
  'A Y' => 6 + 2, # win  by paper 
  'A Z' => 0 + 3, # lose by scissors
  'B X' => 0 + 1, # lose by rock
  'B Y' => 3 + 2, # draw by paper
  'B Z' => 6 + 3, # win  by scissors
  'C X' => 6 + 1, # win  by rock
  'C Y' => 0 + 2, # lose by paper
  'C Z' => 3 + 3, # draw by scissors
}

p input.sum { |row| score[row] }

# PART II

score = {
  'A X' => 0 + 3, # lose by scissors
  'A Y' => 3 + 1, # draw by rock
  'A Z' => 6 + 2, # win  by paper
  'B X' => 0 + 1, # lose by rock
  'B Y' => 3 + 2, # draw by paper
  'B Z' => 6 + 3, # win  by scissors
  'C X' => 0 + 2, # lose by paper
  'C Y' => 3 + 3, # draw by scissors
  'C Z' => 6 + 1, # win  by rock
}

p input.sum { |row| score[row] }

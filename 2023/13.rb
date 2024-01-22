# https://adventofcode.com/2023/day/13

input = File.read('inputs/13.txt').split("\n\n")

def columns_mirrored?(mirror, c1, c2)
  mirror.all? { |row| row[c1] == row[c2] }
end

def rows_mirrored?(mirror, row1, row2)
  mirror[row1] == mirror[row2]
end

def score_mirror(mirror, prev_score)
  (0..mirror.size - 2).each do |y|
    row1 = y
    row2 = y + 1

    ok_so_far = true
    while ok_so_far && row1 >= 0 && row2 <= mirror.size - 1
      ok_so_far = rows_mirrored?(mirror, row1, row2)
      row1 -= 1
      row2 += 1
    end

    next unless ok_so_far

    score = (y + 1) * 100

    return score if prev_score.nil? || prev_score != score
  end

  (0..mirror[0].size - 2).each do |x|
    col1 = x
    col2 = x + 1

    ok_so_far = true
    while ok_so_far && col1 >= 0 && col2 <= mirror[0].size - 1
      ok_so_far = columns_mirrored?(mirror, col1, col2)
      col1 -= 1
      col2 += 1
    end

    next unless ok_so_far

    score = x + 1

    return score if prev_score.nil? || prev_score != score
  end

  0
end

def score_part2(mirror, prev_score)
  mirror.each_with_index do |row, y|
    row.chars.each_with_index do |col, x|
      mirror[y][x] = col == '.' ? '#' : '.'

      score = score_mirror(mirror, prev_score)
      return score if score > 0

      mirror[y][x] = col # backtrack
    end
  end

  raise 'no solution'
end

total_p1 = 0
total_p2 = 0

input.each do |mirror|
  mirror = mirror.split("\n")

  score = score_mirror(mirror, nil)

  total_p1 += score
  total_p2 += score_part2(mirror, score)
end

# PART I

p total_p1

# PART II

p total_p2

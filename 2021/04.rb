# https://adventofcode.com/2021/day/4

nums, *boards = File.read('inputs/04.txt').split("\n\n")

nums = nums.split(',').map(&:to_i)

boards = boards.map do |b|
  b.split("\n").map { |line| line.split.map(&:to_i) }
end

def solve(nums, boards, find_last_winner)
  selected = Array.new(boards.size) { Set.new }
  winning_boards = Set.new

  nums.each do |num|
    boards.each_with_index do |board, i|
      next if winning_boards.include?(i)

      board.each_with_index do |row, y|
        row.each_with_index do |col, x|
          next if col != num

          selected[i] << [x, y]

          num_selected_in_row = selected[i].count { |_, sy| sy == y }
          num_selected_in_col = selected[i].count { |sx, _| sx == x }

          next unless num_selected_in_row == 5 || num_selected_in_col == 5

          winning_boards << i

          next if find_last_winner && winning_boards.size < boards.size

          unmarked_sum = 0
          board.each_with_index do |row, y|
            row.each_with_index do |col, x|
              unmarked_sum += col unless selected[i].include?([x, y])
            end
          end

          return unmarked_sum * num
        end
      end
    end
  end
end

# PART I
p solve(nums, boards, false)

# PART II
p solve(nums, boards, true)

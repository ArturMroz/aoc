# https://adventofcode.com/2022/day/12

require 'set'

terrain = []
start   = nil
goal    = nil

File.read('inputs/12.txt').split("\n").each_with_index do |row, y|
  terrain << row.chars.map.with_index do |val, x|
    case val 
    when 'S'
      start = [x, y]
      'a'.ord
    when 'E'
      goal = [x, y]
      'z'.ord
    else
      val.ord
    end
  end
end

DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]]

def bfs(terrain, start, goal)
  seen          = Set[goal]
  frontier      = [goal]
  frontier_next = []
  level         = 0

  until frontier.empty?
    frontier.each do |curx, cury|
      # return level if [curx, cury] == start        # part I
      return level if terrain[cury][curx] == 'a'.ord # part II

      DIRECTIONS.each do |dx, dy|
        x = curx + dx
        y = cury + dy

        next if x < 0 || x >= terrain[0].size || y < 0 || y >= terrain.size 
        next if seen.include?([x, y]) || terrain[cury][curx] - terrain[y][x] > 1 

        frontier_next << [x, y]
        seen          << [x, y]
      end
    end

    frontier      = frontier_next
    frontier_next = []
    level += 1
  end
end

p bfs(terrain, start, goal)

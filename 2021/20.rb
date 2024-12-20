# https://adventofcode.com/2021/day/20

input = File.read('inputs/20.txt').split("\n\n")

algo, img = input

algo = algo.chars.map { |ch| ch == '#' }
img  = img.split("\n").map(&:chars)

OFFSETS = [-1, 0, 1].repeated_permutation(2).freeze

def enhance(num_steps, algo, img)
  canvas = Hash.new(false)

  img.each_with_index do |row, y|
    row.each_with_index do |char, x|
      canvas[[x, y]] = char == '#'
    end
  end

  min = -1
  max = img.size + 1

  num_steps.times do |step|
    canvas_next = {}
    canvas.default = step.even? ? false : algo[0]

    (min..max).each do |y|
      (min..max).each do |x|
        num = 0
        OFFSETS.each do |dy, dx|
          num = (num << 1) | (canvas[[x + dx, y + dy]] ? 1 : 0)
        end

        canvas_next[[x, y]] = algo[num]
      end
    end

    canvas = canvas_next

    min -= 1
    max += 1
  end

  canvas.values.count { |v| v }
end

# PART I
p enhance(2, algo, img)

# PART II
p enhance(50, algo, img)

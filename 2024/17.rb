# https://adventofcode.com/2024/day/17

input = File.read('inputs/17.txt').split("\n\n")

registers, program = input

a, b, c = registers.lines.map { |line| line.split(': ').last.to_i }
program = program.scan(/\d/).map(&:to_i)

def run(program, a, b, c)
  ip  = 0
  buf = []

  while ip < program.size
    ins     = program[ip]
    operand = program[ip + 1]

    ip += 2

    combo_operand =
      case operand
      when 0..3 then operand
      when 4    then a
      when 5    then b
      when 6    then c
      end

    case ins
    when 0 # adv
      a /= (2**combo_operand)
    when 1 # bxl
      b ^= operand
    when 2 # bst
      b = combo_operand % 8
    when 3 # jnz
      ip = operand if a != 0
    when 4 # bxc
      b ^= c
    when 5 # out
      buf << combo_operand % 8
    when 6 # bdv
      b = a / (2**combo_operand)
    when 7 # cdv
      c = a / (2**combo_operand)
    end
  end

  buf
end

# PART I

puts run(program, a, b, c).join(',')

# PART II

q = [0]
(1..program.size).each do |step|
  nq = []

  q.each do |candidate|
    candidate <<= 3

    (0b000..0b111).each do |bit_append|
      new_candidate = candidate | bit_append

      if run(program, new_candidate, 0, 0) == program[-step..]
        nq << new_candidate
      end
    end
  end

  q = nq
end

p q.min

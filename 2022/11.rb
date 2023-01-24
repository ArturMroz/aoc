# https://adventofcode.com/2022/day/11

Monkey = Struct.new(:items, :op, :rule, :pass, :fail, :num_touched)

monkeys = File.read('inputs/11.txt').split("\n\n").map do |monkey_raw|
  m = monkey_raw.split("\n")

  items = m[1].scan(/\d+/).map(&:to_i)
  op    = eval("proc { |old| #{m[2].split("=").last} }")
  rule, pass, fail = m[3..5].map { |row| row[/\d+/].to_i }

  Monkey.new(items, op, rule, pass, fail, 0)
end

product = monkeys.map(&:rule).reduce(&:*)

# 20.times do   # part I
10_000.times do # part II
  monkeys.each do |monkey|
    until monkey.items.empty? do 
      item = monkey.items.pop
      monkey.num_touched += 1

      # worry_lvl = monkey.op.(item) / 3     # part I
      worry_lvl = monkey.op.(item) % product # part II

      throw_to = (worry_lvl % monkey.rule == 0) ? monkey.pass : monkey.fail
      monkeys[throw_to].items << worry_lvl
    end
  end
end

p monkeys.map(&:num_touched).sort.last(2).reduce(&:*)

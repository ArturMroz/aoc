# https://adventofcode.com/2022/day/10

# PART I

x = 1
history = []

File.read('inputs/10.txt').split("\n").each do |op|
  history << x
  case op.split
  in ['addx', arg]
    history << x
    x += arg.to_i
  in ['noop']
    # nothing
  end 
end

p (20..220).step(40).sum { |i| i * history[i-1] }

# PART II

screen_width = 40

history.each_with_index do |x, i|
  pos = i % screen_width

  if x-1 <= pos && pos <= x+1  
    print '#'
  else
    print '.'
  end

  puts if pos == screen_width-1
end

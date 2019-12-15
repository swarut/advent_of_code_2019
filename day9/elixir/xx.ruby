Program = open("input.txt").read.scan(/-?\d+/).map(&:to_i)

def run(input)
  input = input.reverse
  p = Program.clone
  ip = 0
  rb = 0 # relative base
  loc = lambda {|i|
    ll = (p[ip]/10**(i+1))%10
    puts "-------ll = #{ll}"
    case ll
    when 0
      p[ip+i]
    when 1
      ip+i
    when 2
      p[ip+i]+rb
    end
  }
  param = lambda {|i| p[loc[i]] || 0 }
  output = []
  while true
    # puts "ip = #{ip}, p[ip] = #{p[ip]}"
    case p[ip]%100
    when 1
      puts "Read [1], ip = #{ip}, find #{param[1]} + #{param[2]} and store in position #{loc[3]}"
      p[loc[3]] = param[1] + param[2]
      ip += 4
    when 2
      puts "Read [2], ip = #{ip}, find #{param[1]} * #{param[2]} and store in position #{loc[3]}"
      p[loc[3]] = param[1] * param[2]
      ip += 4
    when 3
      puts "Read [3], ip = #{ip}, get input and store at position #{loc[1]}"
      p[loc[1]] = input.pop
      ip += 2
    when 4
      puts "Read [4], ip = #{ip}, output #{param[1]}"
      output << param[1]
      ip += 2
    when 5
      puts "Read [5], ip = #{ip}, check if #{param[1]} is non zero?, if so jump to #{param[2]} "
      ip = (param[1] != 0 ? param[2] : ip+3)
    when 6
      puts "Read [6], ip = #{ip}, check if #{param[1]} is zero?, if so jump to #{param[2]} "
      ip = (param[1] == 0 ? param[2] : ip+3)
    when 7
      puts "Read [7], ip = #{ip}, check if #{param[1]} < #{param[2]}, if so set 1 to position #{loc[3]}"
      p[loc[3]] = (param[1] < param[2] ? 1 : 0)
      ip += 4
    when 8
      puts "Read [8], ip = #{ip}, check if #{param[1]} == #{param[2]}, if so set 1 to position #{loc[3]}"
      p[loc[3]] = (param[1] == param[2] ? 1 : 0)
      ip += 4
    when 9
      puts "Read [9], ip = #{ip}, set from #{rb} to #{rb + param[1]}"
      rb += param[1]
      ip += 2
    when 99
      break
    end
  end
  output
end

puts run([1])
puts run([2])

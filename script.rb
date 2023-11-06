# frozen_string_literal: true

puts 'Welcome to Mastermind'
puts "You will be guessing the computer's code"

def create_code
  code = []
  4.times do
    prng = Random.new
    # adds a random integer from 0-5 to the code array
    code << prng.rand(6)
  end
  code
end

def make_guess
  print '> '
  gets.chomp.split('')
end

# count number of pegs with correct color and correct position
def count_color(guess, code)
  color = 0
  guess.each_with_index do |peg, i|
    color += 1 if peg.to_i == code[i]
  end
  color
end

# count number of pegs with correct color in wrong position
def count_white(guess, code)
  white = 0
  guess.each_with_index do |peg, i|
    next if peg.to_i == code[i]

    white += 1 if code.include?(peg.to_i)
  end
  white
end

# count number of pegs with wrong color
# includes duplicate colors in guess that don't exist in secret code
def count_blank(guess, code)
  blank = 0
  guess.each do |peg|
    blank += 1 if code.count(peg.to_i).zero?
  end
  # check for extra duplicates in guess
  arr = [0, 1, 2, 3, 4, 5]
  arr.each do |val|
    diff = guess.count(val.to_s) - code.count(val)
    blank += diff if diff.positive? && code.count(val).positive?
  end
  blank
end

# run game 12 times
code = create_code
victory = false

12.times do
  guess = make_guess
  color = count_color(guess, code)
  white = count_white(guess, code)
  blank = count_blank(guess, code)
  total = color + white + blank
  diff = total - 4
  white -= diff
  color.times { print '* ' if color.positive? }
  white.times { print '_ ' if white.positive? }
  puts ''
  if color == 4
    puts 'Correct!'
    victory = true
    break
  end
end

puts "Sorry, you didn't guess the code." if victory == false
puts "The code was #{code.join}"

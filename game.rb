require "pry-byebug"

class Players
    attr_reader :username, :weapon
    attr_accessor :turn
  def initialize(username, weapon, turn)
    @username = username
    @weapon = weapon
    @turn = 1
  end
end

class GameBoard
  attr_accessor :board, :winner, :loser
  def initialize
    @board = [1,2,3,4,5,6,7,8,9]
    @winner = nil
    @loser = nil
  end
end

def check_round(board, weapon)
  # check horizontal lines case
  indexes = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
  indexes.map do |index|
    if board[index[0]] == board[index[1]] && board[index[1]] == board[index[2]]
      return true
    end
  end

  

  # check all other cases
  positions = []
  board.each_with_index do |cell, index|
    cell == weapon ? positions.push(index + 1) : true
  end

  distances = []

  while positions.length > 1
    current_pos = positions.shift
    for pos in positions do
      distances.push((current_pos - pos).abs)
    end
  end 

  reduced_distances = distances.reduce(Hash.new(0)) do |results, distance|
    results[distance] += 1
    results
  end
  p reduced_distances

  check_distances = reduced_distances.map do |key, value|
    if value == 2 && key == 2
      for index in [2, 4, 6]
        if board[index] != weapon 
          return false
        end
      end
      return true
    end
    value == 2 && key > 2 ? true : false
  end

  check_distances.any? {|check| check}

end

def print_board(board, winner=nil, loser=nil)
  if winner
    5.times {puts}
    puts "winner: #{winner.username}"
    puts "loser: #{loser.username}"
  else
    5.times {puts}
    puts "winner: "
    puts "loser: "
  end

  puts "          #{board[0]} | #{board[1]} | #{board[2]}"
  puts "          --+---+--"
  puts "          #{board[3]} | #{board[4]} | #{board[5]}"
  puts "          --+---+--"
  puts "          #{board[6]} | #{board[7]} | #{board[8]}"



end

puts "Player1, enter your username"
username1 = gets.chomp
puts "And your weapon"
weapon1 = gets.chomp
puts "Player2, enter your username"
username2 = gets.chomp
puts "And your weapon"
weapon2 = gets.chomp

player1 = Players.new(username1, weapon1, true)
player2 = Players.new(username2, weapon2, false)
current_player = player1

board = GameBoard.new
game_over = false

while !game_over    


  if player1.turn == player2.turn
    current_player = player1
    other_player = player2
  else
    current_player = player2
    other_player = player1
  end

  print_board(board.board)

  puts "#{current_player.username} pick a cell"
  cell = gets  

  board.board[cell.to_i - 1] = current_player.weapon

  if player1.turn > 2
    game_over = check_round(board.board, current_player.weapon)
  end

  if game_over
    board.winner = current_player
    board.loser = other_player
  end

  print_board(board.board, board.winner, board.loser)

  current_player.turn += 1
end



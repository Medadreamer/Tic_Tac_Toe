require "pry-byebug"

class Players
    attr_reader :username, :weapon
    attr_accessor :turn
  def initialize(username, weapon)
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
    2.times {puts}
    puts "winner: #{winner.username}"
    puts "loser: #{loser.username}"
  else
    2.times {puts}
    puts "winner: "
    puts "loser: "
  end

  puts "          #{board[0]} | #{board[1]} | #{board[2]}"
  puts "          --+---+--"
  puts "          #{board[3]} | #{board[4]} | #{board[5]}"
  puts "          --+---+--"
  puts "          #{board[6]} | #{board[7]} | #{board[8]}"



end


#sign player one in
puts "Player1, enter your username"
username1 = gets.chomp
puts "And your weapon: X or O"
weapon1 = gets.chomp

while weapon1 != "X" && weapon1 != "O"
  puts "Please pick either X or O"
  weapon1 = gets.chomp
end 

# sign player two in
2.times {puts}
puts "Player2, enter your username"
username2 = gets.chomp

# assign second weapon to second player
weapons = ["X", "O"]
weapon2 = weapons[1] if weapon1 == weapons[0]
weapon2 = weapons[0] if weapon1 == weapons[1]
puts "your weapon is #{weapon2}"

# Create players
player1 = Players.new(username1, weapon1)
player2 = Players.new(username2, weapon2)

board = GameBoard.new
game_over = false

# initiate the game
while !game_over    

  # pick the player that gets to play this round
  if player1.turn == player2.turn
    current_player = player1
    other_player = player2
  else
    current_player = player2
    other_player = player1
  end

  print_board(board.board)

  # pick a weapon and store player's choice
  puts "#{current_player.username} pick a cell"
  cell = gets.chomp.to_i

  # check whether the player is cooperating
  while cell < 1 || cell > 9
    puts "#{current_player.username} pick a REAL cell! Please."
    cell = gets.chomp.to_i
  end

  # store player's move
  board.board[cell.to_i - 1] = current_player.weapon

  # start checking rounds for a winner after enough moves
  if player1.turn > 2
    game_over = check_round(board.board, current_player.weapon)
  end

  # pick wich one gets to pop champagne
  if game_over
    board.winner = current_player
    board.loser = other_player
  end

  # print the board one last time with winner and loser
  print_board(board.board, board.winner, board.loser) if board.winner

  # update turns
  current_player.turn += 1
end



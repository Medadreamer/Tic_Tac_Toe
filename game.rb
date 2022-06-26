class Players
    attr_reader :username, :weapon
  def initialize(username, weapon)
    @username = username
    @weapon = weapon
  end
end

class GameBoard
  attr_accessor :board
  def initialize
    @board = [
      ['_', '_', '_'],
      ['_', '_', '_'],
      ['_', '_', '_']
    ]
  end
end

player = Players.new("Perzival", "X")
puts player.username
puts player.weapon

board = GameBoard.new
p board.board
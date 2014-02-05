require            'colorize'
require_relative   'board'
#require_relative   'pieces'
require            'io/console'

# use STDIN.getch  will give one character at a time from
# system('clear')

class InCheckError < StandardError
  def initialize(msg = "Moving that piece would leave your defenseless king under attack!@!!!")
    super
  end
end

class SelectionError < StandardError
  def initialize(msg = "There is no piece there")
    super
  end
end

class EndpointError < StandardError
  def initialize (msg = "That piece can't move there")
    super
  end
end

class ChessGame
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}

  end


  def play
    to_move = :white
    until game_over?
      @board.render
      @players[to_move].play_turn


      to_move = (to_move == :white ? :black : :white)
    end
    @board.render
  end


  def game_over?
    false
  end
end


class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end
  #handle user input

  def play_turn
    gets

  end
end

p1 = Player.new("TJ")
p2 = Player.new("Kevin")

game = ChessGame.new(p1, p2)
game.play
# chessboard.render
#chessboard.move([7, 5], [4, 5])
# chessboard.move([6, 5], [6, 7])
# p chessboard.checkmate?(:white)
# chessboard.render
# chessboard.move([2, 7], [3, 7])
# chessboard.render
# chessboard.move([3, 6], [5, 5])
#
# chessboard.render
#
# chessboard.move([5, 5], [6, 7])
#
# chessboard.render
#
# chessboard.move([7, 7], [7, 2])
#
# chessboard.render
#
#
# chessboard.move([7, 2], [2, 2])
#
# chessboard.render
#
#
# chessboard.move([2, 2], [1, 2])
#
# chessboard.render

# begin
# chessboard.render
# chessboard.move([4, 3], [4, 4])
# chessboard.render
# rescue SelectionError => e
#   puts e.message
#
# end
#
# begin
# chessboard.render
# chessboard.move([4, 4], [4, 5])
# chessboard.render
# rescue EndpointError => e
#   puts e.message
#
# end









require            'colorize'
require_relative   'board'
require_relative   'pieces'
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
  #Chess logic
end



class Player
  #handle user input
end



chessboard = Board.new
# chessboard.render
#chessboard.move([7, 5], [4, 5])
chessboard.render
chessboard.move([2, 5], [1, 5])
chessboard.render
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









require            'colorize'
require_relative   'board'
require            'io/console'

# use STDIN.getch  will give one character at a time from
# system('clear')

class InCheckError < StandardError
  def initialize(msg = "Moving that piece would leave your defenseless king under attack!@!!!")
    super
  end
end

class SelectionError < StandardError
  def initialize(msg = "There is no piece there. Do you even lift?\n")
    super
  end
end

class WrongTeamError < StandardError
  def initialize(msg = "You can't move the enemy teams pieces. Please select your own pieces\n")
    super
  end
end

class EndpointError < StandardError
  def initialize (msg = "That piece can't move there. Please select a valid endpoint\n")
    super
  end
end

class BadInputError < TypeError
  def initialize (msg = "Please use algebraic chess notation.  eg.  'e3 e4' \n")
    super
  end
end

class ChessGame
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
    @turn = :white
  end


  def play
    until game_over?(@turn)
      @board.render
      puts (@turn == :white ? "White" : "Black") + " to move: "

      begin
      from, to = @players[@turn].play_turn
      @board.move(from, to, @turn)
      rescue SelectionError => e
        puts e.message
        retry
      rescue WrongTeamError => e
        puts e.message
        retry
      rescue EndpointError => e
        puts e.message
        retry
      rescue BadInputError => e
        puts e.message
        retry
      end

      @turn = (@turn == :white ? :black : :white)
    end

    @board.render
    loser = game_over?(:white) ? "WHITE" : "BLACK"
    puts "#{loser} HAS BEEN MATED!"
  end

  private

  def game_over?(color)
    @board.in_check?(color) && @board.checkmate?(color)
  end
end


class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  COLUMNS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def play_turn
    from, to = gets.chomp.split(" ")
    raise BadInputError unless valid_input?(from, to)

    from_col, from_row = from[0], from[1]
    move_from = [COLUMNS[from_col], (8 - Integer(from_row))]

    to_col, to_row = to[0], to[1]
    move_to = [COLUMNS[to_col], (8 - Integer(to_row))]

    [move_from, move_to]
  end

  private

  def valid_input?(from, to)
    return false if from.nil? || to.nil?
    return false if from.length != 2 && to.length != 2
    return false unless ('a'..'h').include?(from[0]) && from[1].to_i.between?(1,8)
    return false unless ('a'..'h').include?(to[0]) && to[1].to_i.between?(1,8)

    true
  end
end

p1 = Player.new("TJ")
p2 = Player.new("Kevin")

game = ChessGame.new(p1, p2)
game.play










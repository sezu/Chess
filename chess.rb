require            'colorize'
require_relative   'board'
require_relative   'errors'
require            'io/console'

# use STDIN.getch  will give one character at a time from
# system('clear')

class ChessGame
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
    @turn = :white
  end

  def play
    until game_over?
      show_board
      prompt_player_to_move
      take_turn
      swap_turn
    end
    show_board
    finish_game
  end

  private

  def show_board
    system('clear')
    puts @board
  end

  def prompt_player_to_move
    puts (@turn == :white ? "White" : "Black") + " to move: "
  end

  def swap_turn
     @turn = (@turn == :white ? :black : :white)
  end

  def take_turn
    begin
      from, to = @players[@turn].play_turn
      @board.move(from, to, @turn)
    rescue SelectionError, WrongTeamError, EndpointError, BadInputError => e
      puts e.message
      retry
    end
  end

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def winner
    return false unless game_over?
    return :white if @board.checkmate?(:black)
    :black
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def finish_game
    loser = other_color(winner)
    puts "#{loser} HAS BEEN MATED!"
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

    move_from = algebraic_to_coord(from)
    move_to = algebraic_to_coord(to)

    [move_from, move_to]
  end

  private

  def algebraic_to_coord(alg)
    col, row = alg.split('')
    [COLUMNS[col], (8 - Integer(row))]
  end

  def valid_input?(from, to)
    return false if from.nil? || to.nil?
    return false if from.length != 2 && to.length != 2
    return false unless ('a'..'h').include?(from[0]) && from[1].to_i.between?(1, 8)
    return false unless ('a'..'h').include?(to[0]) && to[1].to_i.between?(1, 8)

    true
  end
end

p1 = Player.new("TJ")
p2 = Player.new("Kevin")

game = ChessGame.new(p1, p2)
game.play










require            'colorize'
require_relative   'board'
require_relative   'errors'
require            'io/console'

# use   will give one character at a time from
# system('clear')

class ChessGame
  def initialize(player1, player2)
    @board = Board.new
    @players = {:white => player1, :black => player2}
    @turn = :white
    @cursor = [0, 0]
    @cursor_selected = nil
  end

  def play
    until game_over?
      puts "Got back to the top of the play loop"
      show_board
      #prompt_player_to_move
      #take_turn
      magic_cursor
      swap_turn
    end
    show_board
    finish_game
  end

  private

  def show_board
    system('clear')

    puts @board.to_s(@cursor, @cursor_selected)
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

  def magic_cursor
    begin
      @cursor_selected = nil
      move = []

      until move.count == 2
        prompt_player_to_move
        action = STDIN.getch
        case action
        when "d"
          @cursor[0] += 1 if @cursor[0] + 1 < 8
        when "w"
          @cursor[1] -= 1 if @cursor[1] - 1 >= 0
        when "a"
          @cursor[0] -= 1 if @cursor[0] - 1 >= 0
        when "s"
          @cursor[1] += 1 if @cursor[1] + 1 < 8
        when " "
          @cursor_selected = @cursor.dup unless @cursor_selected
          move << @cursor.dup
        when "q"
          raise StandardError
        end
        show_board
      end
    @board.clear_selected_moves
    @cursor_selected = nil
    @board.move(move[0], move[1], @turn)
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










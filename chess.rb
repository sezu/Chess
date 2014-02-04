require 'colorize'
class Board
  #Handle peices on board
  def initialize
    set_up_board
    set_up_pieces
  end

  def [](pos)
    x, y = pos
    @board[y][x]
  end

  # def []= (piece)
#     @board[y][x] = piece
#   end

  def in_check?(color)
    #returns whether a player is in check

    #find position of the king on the board
    #any of opposing pieces can move to that position
  end

  def move(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos


    #update 2d board and piece's position
    # find if piece in start position
    # find possible moves for rook
    # if possible_moves.include?(end_position)
    # update board and piece with new position.
    good_move = @board[start_y][start_x].moves(start_pos).include?(end_pos)
    p good_move
    if good_move
      @board[end_y][end_x] = @board[start_y][start_x]
      @board[end_y][end_x].pos = end_pos
      @board[start_y][start_x] = nil
    end
    #raise exception if
    # - there is no piece at start
    # - the piece cannot move to end
  end

  def render
    @board.each_with_index do |rows, index|
      color = (index % 2 == 0 ? false : true )
      rows.each do |square|
        color = !color
        print (square.nil? ? "   " : square.to_s ).colorize( :background => (color ? :white : :black))
      end
      print "\n"
    end
    print "\n"
  end

  private

  def set_up_board
    @board = Array.new(8) { Array.new(8) }
  end

  def set_up_pieces
    @board[2][1] = Rook.new(@board, [1, 2], :red)
    @board[2][2] = Bishop.new(@board, [2, 2], :red)
    @board[5][5] = Knight.new(@board, [5, 5], :red)
    @board[7][7] = Rook.new(@board, [7, 7], :blue)
    @board[7][6] = Bishop.new(@board, [6, 7], :blue)
    @board[6][3] = Knight.new(@board, [3, 6], :blue)
  end

end


class Piece
  attr_accessor :pos
  attr_reader :board, :color
  # Common piece logic
  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
  end

  def moves(pos)
    #return array of possible moves
  end
end


class SlidingPiece < Piece
  HORIZONTAL = [[0, 1], [1, 0], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def moves(pos)
    x, y = pos
    #return array of possible moves
    possible_moves = []

    move_dir.each do |direction|
      dx, dy = direction
      x_copy, y_copy = x + dx, y + dy
      while x_copy.between?(0, 7) && y_copy.between?(0, 7)

        #break if !@board[y_copy][x_copy].nil? && @board[y_copy][x_copy].color == @color
        if @board[y_copy][x_copy].nil?
          possible_moves << [x_copy, y_copy]
          x_copy += dx
          y_copy += dy
        else
          possible_moves << [x_copy, y_copy] if @color != @board[y_copy][x_copy].color
          break
        end
        #break if !@board[y_copy][x_copy].nil? && @board[y_copy][x_copy].color != @color
      end
    end
    p possible_moves
    possible_moves
  end


  #Sliding piece logic
end

class SteppingPiece < Piece
  #SteppingPiece logic

  def moves(pos)
    x, y = pos
    #return array of possible moves
    possible_moves = []

    steps.each do |step|
      dx, dy = step
      x_copy, y_copy = x + dx, y + dy
      if x_copy.between?(0, 7) && y_copy.between?(0, 7)
        possible_moves << [x_copy, y_copy]
      end
    end
    p possible_moves
    possible_moves
    #return array of possible moves
  end


end


class Bishop < SlidingPiece
  def move_dir
    DIAGONAL
  end

  def to_s
    " \u265D ".colorize(@color)
  end
end

class Rook < SlidingPiece
  def move_dir
    HORIZONTAL
  end

  def to_s
    " \u265C ".colorize(@color)
  end
end

class Queen < SlidingPiece
  def move_dir
    HORIZONTAL + DIAGONAL
  end

  def to_s
    " \u265B ".colorize(@color)
  end
end



class Knight < SteppingPiece
  KNIGHT_STEPS = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]

  def steps
    KNIGHT_STEPS
  end

  def to_s
    " \u265E ".colorize(@color)
  end
end

class King < SteppingPiece
  KING_STEPS = [[0, 1], [1, 0], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def steps
    KING_STEPS
  end

  def to_s
    " \u265A ".colorize(@color)
  end
end



class Pawn < Piece

  PAWN_STEPS = {
    :blue => { :first  => [[0, -2],[0, -1]],
                :move   => [[0, -1]]
              },

    :red => { :first  => [[0, 2], [0, 1]],
                :move   => [[0, 1]]
              }
  }

  def moves(pos)
    x, y = pos
    #return array of possible moves
    possible_moves = []
    starting_y = (color == :red) ? 1 : 6
    steps = (y == starting_y ? :first : :move)
    p @color
    p steps
    PAWN_STEPS[@color][steps].each do |step|
      dx, dy = step
      x_copy, y_copy = x + dx, y + dy

      if x_copy.between?(0, 7) && y_copy.between?(0, 7)
        possible_moves << [x_copy, y_copy]
      end
    end
    p possible_moves
    possible_moves
  end

  def to_s
    " \u265F ".colorize(@color)
  end
end




chessboard = Board.new
chessboard.render

chessboard.move([6, 7], [1, 2])

chessboard.render

























class ChessGame
  #Chess logic
end



class Player
  #handle user input
end
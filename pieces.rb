class Piece
  COLORS = {:white => :blue, :black => :red}
  PIECE_CHARS = { "Pawn"    => " \u265F  ",
                  "Knight"  => " \u265E  ",
                  "Rook"    => " \u265C  ",
                  "Bishop"  => " \u265D  ",
                  "Queen"   => " \u265B  ",
                  "King"    => " \u265A  "
                }

  attr_accessor :pos, :board
  attr_reader :color

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
  end

  def in_bounds?(x,y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def attacking_my_team?(x, y)
    @color == @board[x, y].color
  end

  def attacking_enemy?(x, y)
    @board[x, y] && @color != @board[x, y].color
  end

  def empty_square?(x, y)
    @board[x, y].nil?
  end

  def valid_moves(pos)
    moves(pos).select { |move| !move_into_check?(move) }
  end

  def move_into_check?(pos)
    x, y = pos
    current_x, current_y = self.pos
    new_board = @board.dup
    new_board.move!([current_x, current_y], [x, y])
    new_board.in_check?(self.color)
  end

  def to_s
    PIECE_CHARS[self.class.to_s].colorize(COLORS[@color])
  end

  def moves(pos)
    possible_moves = []

    move_vectors.each do |vector|
      possible_moves += moves_in_direction(pos, vector)
    end

    possible_moves
  end

  def moves_in_direction(pos, vector)
    x, y = pos
    dx, dy = vector

    possible_moves = []

    max_steps.times do
      x, y = x + dx, y + dy
      break unless in_bounds?(x, y)

      if empty_square?(x, y)
        possible_moves << [x, y]
      else
        possible_moves << [x, y] unless attacking_my_team?(x, y)
        break
      end
    end

    possible_moves
  end

  def max_steps
    self.class::MAX_STEPS
  end
end

class SlidingPiece < Piece
  HORIZONTAL = [[0, 1], [1, 0], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  MAX_STEPS = 8
end


class SteppingPiece < Piece
  MAX_STEPS = 1
end


class Bishop < SlidingPiece
  def move_vectors
    DIAGONAL
  end
end

class Rook < SlidingPiece
  def move_vectors
    HORIZONTAL
  end
end

class Queen < SlidingPiece
  def move_vectors
    HORIZONTAL + DIAGONAL
  end
end

class Knight < SteppingPiece
  KNIGHT_STEPS = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]

  def move_vectors
    KNIGHT_STEPS
  end
end

class King < SteppingPiece
  KING_STEPS = [[0, 1], [1, 0], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def move_vectors
    KING_STEPS
  end
end


class Pawn < Piece
  PAWN_STEPS = {
    :white => { :first  => [[0, -2],[0, -1]],
                :move   => [[0, -1]]
              },

    :black => { :first  => [[0, 2], [0, 1]],
                :move   => [[0, 1]]
              }
  }

  PAWN_ATTACKS = {
                :white  => [[-1, -1],[1, -1]],
                :black  => [[-1, 1], [1, 1]]
  }

  def moves(pos)
    stepping_moves(pos) + attacking_moves(pos)
  end

  def stepping_moves(pos)
    x, y = pos
    possible_moves = []

    move_vectors(pos).each do |dx, dy|
      end_x, end_y = x + dx, y + dy
      possible_moves << [end_x, end_y] if empty_square?(end_x, end_y)
    end

    possible_moves
  end

  def attacking_moves(pos)
    x_start, y_start = pos
    possible_attacks = []

    attack_vectors.each do |dx, dy|
      x, y = x_start + dx, y_start + dy
      if in_bounds?(x, y) && attacking_enemy?(x, y)
        possible_attacks << [x, y]
      end
    end

    possible_attacks
  end

  def move_vectors(pos)
    x, y = pos
    steps = starting_position?(y)
    PAWN_STEPS[@color][steps]
  end

  def attack_vectors
    PAWN_ATTACKS[@color]
  end

  def starting_position?(y)
    starting_row = (color == :black) ? 1 : 6
    y == starting_row ? :first : :move
  end
end

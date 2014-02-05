class Piece
  COLORS = {:white => :blue, :black => :red}
  PIECE_CHARS = { "Pawn"    => " \u265F ",
                  "Knight"  => " \u265E ",
                  "Rook"    => " \u265C ",
                  "Bishop"  => " \u265D ",
                  "Queen"   => " \u265B ",
                  "King"    => " \u265A "
                }

  attr_accessor :pos, :board
  attr_reader :color

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
  end

  def moves(pos)
    raise NotImplementedError
  end

  def in_bounds?(x,y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def attacking_my_team?(x, y)
    @color == @board[x, y].color
  end

  def attacking_enemy?(x, y)
    @color != @board[x, y].color
  end

  def empty_square?(x, y)
    @board[x, y].nil?
  end

  def valid_moves(pos)
    good_moves =  moves(pos).select do |move|
      !move_into_check?(move)
    end
    p good_moves
    good_moves
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
end

class SlidingPiece < Piece
  HORIZONTAL = [[0, 1], [1, 0], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def moves(pos)
    x_start, y_start = pos
    possible_moves = []

    move_dir.each do |direction|
      dx, dy = direction
      x, y = x_start + dx, y_start + dy

      while in_bounds?(x, y)
        if empty_square?(x, y)
          possible_moves << [x, y]
          x, y = x + dx , y + dy
        else
          possible_moves << [x, y] unless attacking_my_team?(x, y)
          break
        end
      end
    end
    possible_moves
  end
end


class SteppingPiece < Piece

  def moves(pos)
    x_start, y_start = pos
    possible_moves = []
    steps.each do |step|
      dx, dy = step
      x, y = x_start + dx, y_start + dy

      if in_bounds?(x, y) &&
      (empty_square?(x, y) || !attacking_my_team?(x, y))

        possible_moves << [x, y]
      end
    end

    possible_moves
  end
end


class Bishop < SlidingPiece
  def move_dir
    DIAGONAL
  end
end

class Rook < SlidingPiece
  def move_dir
    HORIZONTAL
  end
end

class Queen < SlidingPiece
  def move_dir
    HORIZONTAL + DIAGONAL
  end
end

class Knight < SteppingPiece
  KNIGHT_STEPS = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]

  def steps
    KNIGHT_STEPS
  end
end

class King < SteppingPiece
  KING_STEPS = [[0, 1], [1, 0], [-1, 0], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def steps
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
    x_start, y_start = pos
    possible_moves = []
    steps = starting_position?(y_start)

    PAWN_STEPS[@color][steps].each do |step|
      dx, dy = step
      x, y = x_start + dx, y_start + dy
      possible_moves << [x, y] if empty_square?(x, y)
    end

    possible_moves += check_attack(pos)
  end

  def check_attack(pos)
    x_start, y_start = pos
    possible_attacks = []

    PAWN_ATTACKS[@color].each do |attack|
      dx, dy = attack
      x, y = x_start + dx, y_start + dy
      if in_bounds?(x, y) &&
      (!empty_square?(x, y) && attacking_enemy?(x, y))
        possible_attacks << [x, y]
      end
    end
    possible_attacks
  end

  def starting_position?(y)
    starting_row = (color == :black) ? 1 : 6
    y == starting_row ? :first : :move
  end
end

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
    moves(pos).select do |move|
      #moves that don't leave you in check

      !move_into_check?(move)
    end
  end

  def move_into_check?(pos)
    x, y = pos
    current_x, current_y = self.pos
    new_board = @board.dup
    puts "before move"
    p new_board
    new_board.move!(self.pos, pos)
    puts "After move"
    p new_board
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
    x, y = pos
    possible_moves = []

    move_dir.each do |direction|
      dx, dy = direction
      x_copy, y_copy = x + dx, y + dy

      while in_bounds?(x_copy, y_copy)
        if empty_square?(x_copy, y_copy)
          possible_moves << [x_copy, y_copy]
          x_copy += dx
          y_copy += dy
        else
          possible_moves << [x_copy, y_copy] unless attacking_my_team?(x_copy, y_copy)
          break
        end
      end

    end
    possible_moves
  end
end


class SteppingPiece < Piece

  def moves(pos)
    x, y = pos
    possible_moves = []

    steps.each do |step|
      dx, dy = step
      x_copy, y_copy = x + dx, y + dy

      if in_bounds?(x_copy, y_copy) &&
      (empty_square?(x_copy, y_copy) || !attacking_my_team?(x_copy, y_copy))

        possible_moves << [x_copy, y_copy]
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
    x, y = pos
    possible_moves = []
    steps = starting_position?(y)

    PAWN_STEPS[@color][steps].each do |step|
      dx, dy = step
      x_copy, y_copy = x + dx, y + dy
      possible_moves << [x_copy, y_copy] if empty_square?(x_copy, y_copy)
    end

    possible_moves += check_attack(pos)
  end

  def check_attack(pos)
    x, y = pos
    possible_attacks = []

    PAWN_ATTACKS[@color].each do |attack|
      dx, dy = attack
      x_copy, y_copy = x + dx, y + dy
      if in_bounds?(x_copy, y_copy) &&
      (!empty_square?(x_copy, y_copy) && attacking_enemy?(x_copy, y_copy))
        possible_attacks << [x_copy, y_copy]
      end
    end
    possible_attacks
  end

  def starting_position?(y)
    starting_row = (color == :black) ? 1 : 6
    y == starting_row ? :first : :move
  end
end

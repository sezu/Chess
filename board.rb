require_relative 'pieces'

class Board
  attr_accessor :board

  def initialize
    set_up_board
    set_up_pieces
  end

  def [](x, y)
    @board[y][x]
  end

  def []=(x, y, val)
    @board[y][x] = val
  end

  def pieces
    @board.flatten.compact
  end

  def king_for(color)
    self.board.flatten.select do |square|
      square.class == King && square.color == color
    end.first
  end

  def other_color(color)
    color == :white ? :black : :white
  end

  def pieces_for(color)
    self.board.flatten.select do |square|
      !square.nil? && square.color == color
    end
  end

  def in_check?(color)
    king_position = king_for(color).pos

    enemies = pieces_for(other_color(color))

    enemies.any? { |piece| piece.moves(piece.pos).include?(king_position) }
  end

  def checkmate?(color)
    return false unless in_check?(color)

    same_team = self.pieces.select do |piece|
      piece.color == color
    end

    same_team.all? do |piece|
      piece.valid_moves(piece.pos).empty?
    end
  end

  def move(start_pos, end_pos, color)
    start_x, start_y = start_pos
    end_x, end_y = end_pos

    moving_piece = self[start_x, start_y]

    raise SelectionError if moving_piece.nil?
    raise WrongTeamError if moving_piece.color != color

    if moving_piece.valid_moves(start_pos).include?(end_pos)
      self[end_x, end_y] = moving_piece
      moving_piece.pos = end_pos
      self[start_x, start_y] = nil
    else
      raise EndpointError
    end
  end

  def move!(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos

    self[end_x, end_y] = self[start_x, start_y]
    self[end_x, end_y].pos = end_pos
    self[start_x, start_y] = nil
  end

  def dup
    new_board = Board.new

    new_board.board = @board.map { |rows| rows.map(&:dup) }

    new_board.pieces.each { |piece| piece.board = new_board }

    new_board
  end

  def to_s
    str = ""
    @board.each_with_index do |rows, idx|
      str << "#{ 8  - idx} "
      color = (idx % 2 == 0 ? false : true )
      rows.each do |square|
        color = !color
        str << (square.nil? ? "    " : square.to_s )
                .colorize( :background => (color ? :white : :black))
      end
      str << "\n"
    end
    str << "  "
    ('a'..'h').each { |i| str << " #{i}  " }
    str << "\n"
    str
  end

  private

  def set_up_board
    @board = Array.new(8) { Array.new(8) }
  end

  PIECES = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  def set_up_pieces
    #To set up pieces individually use: self[1, 2] = Rook.new(self, [1, 2], :black)
    16.times do |num|
      color = (num % 2 == 0 ? :white : :black)
      y = (color == :white ? 6 : 1)
      x = num / 2
      self[x, y] = Pawn.new(self, [x, y], color)
    end

    16.times do |num|
      color = (num % 2 == 0 ? :white : :black)
      y = (color == :white ? 7 : 0)
      x = num / 2
      self[x, y] = PIECES[x].new(self, [x, y], color)
    end
  end
end

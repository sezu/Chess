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

  def in_check?(color)
    king_position = self.board.flatten.select do |square|
      square.class == King && square.color == color
    end.first.pos

    enemies = self.board.flatten.select do |square|
      !square.nil? && square.color != color
    end

    enemies.each do |piece|
      if piece.moves(piece.pos).include?(king_position)
        return true
      end
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      same_team = @board.flatten.select do |square|
      !square.nil? && square.color == color
      end

      escapes = []
      same_team.each do |piece|
        escapes << piece.valid_moves(piece.pos)
      end
    end

    escapes.flatten.empty? ? true : false
  end

  def move(start_pos, end_pos, color)
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    raise SelectionError if self[start_x, start_y].nil?
    raise WrongTeamError if self[start_x, start_y].color != color

    moving_piece = self[start_x, start_y]
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
    new_board = Board.new()

    @board.each_with_index do |rows, y|
      rows.each_with_index do |square, x|
        if square.nil?
          new_board[x, y] = nil
        else
          duped_pos = self[x, y].pos.dup
          x_dup, y_dup = duped_pos
          new_board[x, y] = self[x, y].dup
          new_board[x, y].pos = [x_dup, y_dup]
          new_board[x, y].board = new_board
        end
      end
    end
    new_board
  end

  def render
    to_s
  end

  private

  def set_up_board
    @board = Array.new(8) { Array.new(8) }
  end

  PIECES = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  def set_up_pieces
    #To set up pieces individually use: self[1, 2] = Rook.new(self, [1, 2], :black)
    #Sets up pawns
    16.times do |num|
      color = (num % 2 == 0 ? :white : :black)
      y = (color == :white ? 6 : 1)
      x = num / 2
      self[x, y] = Pawn.new(self, [x, y], color)
    end

    #Set up ROYALTY
    16.times do |num|
      color = (num % 2 == 0 ? :white : :black)
      y = (color == :white ? 7 : 0)
      x = num / 2
      self[x, y] = PIECES[x].new(self, [x, y], color)
    end
  end

  def to_s
    puts
    @board.each_with_index do |rows, idx|
      print "#{ 8  - idx} "
      color = (idx % 2 == 0 ? false : true )
      rows.each do |square|
        color = !color
        print (square.nil? ? "   " : square.to_s ).colorize( :background => (color ? :white : :black))
      end
      print "\n"
    end
    print "  "
    ('a'..'h').each { |i| print " #{i} " }
    print "\n"
  end
end

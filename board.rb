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

    king_for(color).in_check = (in_check?(color) ? true : false)

    if moving_piece.valid_moves(start_pos).include?(end_pos)
      self[end_x, end_y] = moving_piece
      moving_piece.pos = end_pos
      self[start_x, start_y] = nil
      check_for_castle(start_pos, end_pos) if moving_piece.class == King

      if moving_piece.class == King || moving_piece.class == Rook
        moving_piece.moved = true
      end
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

  def check_for_castle(start, end_pos)
    start_x, start_y = start
    end_x, end_y = end_pos

    if (start_x - end_x).abs > 1
      rook_x = (end_x == 2 ? 0 : 7)
      rook_end = (end_x == 2 ? 3 : 5)
      move!([rook_x, start_y], [rook_end, start_y])
      self[rook_x, start_y] = nil
      self[rook_end, start_y].pos = [rook_end, start_y]
    end
  end

  def dup
    new_board = Board.new

    new_board.board = @board.map { |rows| rows.map(&:dup) }

    new_board.pieces.each { |piece| piece.board = new_board }

    new_board
  end


 #  :red,
 # :green,
 # :blue,
 # :magenta,
 # :cyan,
 # :light_red,
 # :light_green,
 # :light_yellow,
 # :light_blue,
 # :light_magenta,
 # :light_cyan,
 # :light_white]

 #self[selected].valid_moves.include?([x,y])

 def selected_valid_moves(x, y)
   return [] if self[x, y].nil?
   @selected_valids ||= self[x, y].valid_moves([x, y])
 end

 def clear_selected_moves
   @selected_valids = nil
 end


  def to_s(cursor, selected)
    str = ""
    @board.each_with_index do |rows, y|
      str << "#{ 8  - y} "
      color = (y % 2 == 0 ? false : true )
      rows.each_with_index do |square, x|
        color = !color

        if [x, y] == selected
          str << (square.nil? ? "    " : square.to_s)
                  .colorize( :background => :red)

        elsif [x, y] == cursor
          str << (square.nil? ? "    " : square.to_s)
                  .colorize( :background => :green)

        elsif selected && selected_valid_moves(selected[0], selected[1]).include?([x,y])
         str << (square.nil? ? "    " : square.to_s)
                 .colorize( :background => :yellow)

        else
          str << (square.nil? ? "    " : square.to_s)
                  .colorize( :background => (color ? :white : :black))
        end
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

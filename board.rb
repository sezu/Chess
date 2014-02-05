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
    #
    # p king_position
    # p self

    enemies = self.board.flatten.select do |square|
      !square.nil? && square.color != color
    end

    enemies.last.pos

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

      same_team.each do |piece|
        if piece.valid_moves(piece.pos).empty?
          return false
        end
      end
    end
    puts "Checkmate!"
    true
  end

  def move(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    raise SelectionError if self[start_x, start_y].nil?

    moving_piece = self[start_x, start_y]
    if moving_piece.valid_moves(start_pos).include?(end_pos)
      self[end_x, end_y] = moving_piece
      moving_piece.pos = end_pos
      self[start_x, start_y] = nil

    end

  end


  def move!(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    #p self[start_x, start_y].class
    self[end_x, end_y] = self[start_x, start_y]
    self[end_x, end_y].pos = end_pos
    self[start_x, start_y] = nil
  end



  def to_s
    9.times { |i| print (i == 0 ? " " : " #{i-1} ") }
    puts
    @board.each_with_index do |rows, idx|
      print "#{idx}"
      color = (idx % 2 == 0 ? false : true )
      rows.each do |square|
        color = !color
        print (square.nil? ? "   " : square.to_s ).colorize( :background => (color ? :white : :black))
      end
      print "\n"
    end
    print "\n"
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

  def set_up_pieces
    # self[1, 2] = Rook.new(self, [1, 2], :black)
#     self[2, 2] = Bishop.new(self, [2, 2], :black)
#     self[5, 5] = Knight.new(self, [5, 5], :black)
#     self[7, 7] = Rook.new(self, [7, 7], :white)
#     self[6, 7] = Bishop.new(self, [6, 7], :white)
#     self[3, 6] = Knight.new(self, [3, 6], :white)

     self[2, 5] = King.new(self, [2, 5], :white)
     # self[4, 5] = Bishop.new(self, [4, 5], :white)
     self[2, 4] = Pawn.new(self, [2, 4], :black)
      self[1, 1] = King.new(self, [1, 1], :black)
 #     self[7, 5] = Rook.new(self, [7, 5], :black)
 #     self[5, 4] = Knight.new(self, [5, 4], :white)

  end
end

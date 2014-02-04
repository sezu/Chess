class Board
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
    king_position = @board.flatten.select do |square|
      square.class == King && square.color == color
    end.first.pos

    enemies = @board.flatten.select do |square|
      !square.nil? && square.color != color
    end

    enemies.each do |piece|
      p "checking enemy"
      #p piece.pos
      #p piece.moves(piece.pos)
      self[4,5].class
      if piece.moves(piece.pos).include?(king_position)
        return true
      end
    end
    false
  end

  def checkmate?(color)
  end

  def move(start_pos, end_pos)
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    raise SelectionError if self[start_x, start_y].nil?

    moving_piece = self[start_x, start_y]

    #p moving_piece.valid_moves(start_pos)#.include?(end_pos)

    if moving_piece.valid_moves(start_pos).include?(end_pos)
      self[end_x, end_y] = moving_piece
      moving_piece.pos = end_pos
      self[start_x, start_y] = nil

    end

  end


  def move!(start_pos, end_pos)
    p start_pos
    start_x, start_y = start_pos
    end_x, end_y = end_pos
    #moving_piece = self[start_x, start_y]

    self[end_x, end_y] = self[start_x, start_y]
    #moving_piece.pos = end_pos
    self[start_x, start_y] = nil
     p self[start_x, start_y].class
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
          new_board[x, y] = self[x, y]
          new_board[x, y].pos = duped_pos
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
     self[4, 5] = Bishop.new(self, [4, 5], :white)
     self[2, 4] = Pawn.new(self, [2, 4], :black)
     self[0, 0] = King.new(self, [0, 0], :black)
     self[7, 5] = Rook.new(self, [7, 5], :black)
     self[5, 4] = Knight.new(self, [5, 4], :white)

  end
end

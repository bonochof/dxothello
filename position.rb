class Position
  attr_accessor :board, :stonenum

  def initialize
    @board = Array.new(BOARDSIZE)
    @stonenum = Array.new(2)
  end
end

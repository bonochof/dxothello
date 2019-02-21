class Director
  @@d = 50
  @@r = @@d / 2
  @@sx = @@sy = 20
  @@ex = @@sx + @@d * SIDE
  @@ey = @@sy + @@d * SIDE
  @@rx = @@ex + 10
  @@STRCOLOR = C_BLUE
  @@STRFONTSIZE = 32
  @@exitFlag = 0
  @@font = Font.new(32)

  def initialize
    @game = Othello.new
    @manturn = BLACK_TURN
    @scene = 0
    @moves = Array.new(MOVENUM)
    $maxdepth = 3
  end

  def initGrp
    @scene_back = Image.new(Window.width, Window.height, C_GREEN)
  end

  def initSE
  
  end

  def waitDisp
  
  end

  def title
    Window.draw(0, 0, @scene_back)
  end

  def getPosFromMouse (mouse_x, mouse_y)
    x = (mouse_x - @@sx + @@d) / @@d
    y = (mouse_y - @@sy + @@d) / @@d
    return @game.getPosition(x, y)
  end

  def manPlayerGUI
    moves = Array.new(MOVENUM)
    moves, num = @game.generateMoves(moves)
    if num == 0
      @game.nextmove = PASSMOVE
      return
    end
    Window.loop do
      if Input.mouse_push?(M_LBUTTON)
        move = getPosFromMouse(Input.mouse_pos_x, Input.mouse_pos_y)
        if @game.isLegalMove(move)
          @game.nextmove = move
          return
        end
      end
    end
    #@game.nextmove = 15
  end

  def showBoard
  
  end

  def game
    num = @game.generateMoves(@moves)
    if num == 0 and @game.isTerminalNode
      if mode == MODE::WEAK
        result = @game.stonenum[WHITE_TURN] - @game.stonenum[BLACK_TURN]
      else
        result = @game.stonenum[BLACK_TURN] - @game.stonenum[WHITE_TURN]
      end
      if result == 0
        Window.draw_font(@@rx, @@ey / 2 - 20, "DRAW!!", @@font)
      else
        Window.draw_font(@@rx, @@ey / 2 - 20, "#{(result > 0 ? "BLACK" : "WHITE")} WIN!!", @@font)
      end
    end
    if @game.turn == @manturn
      manPlayerGUI
    else
      @game.comPlayer
    end
    @game.makeMove(@game.nextmove, 0)
    if @game.nextmove == PASSMOVE
      Window.draw_font(@@rx, @@ey / 2 - 20, "PASS!!", @@font)
      waitDisp
    else
      @game.ply += 1
    end
    showBoard
    if @game.turn == @manturn
    else
    end
    sleep 0.1
  end
end

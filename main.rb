require 'dxopal'
include DXOpal

require_remote "header.rb"
require_remote "position.rb"
require_remote "othello.rb"
require_remote "director.rb"

director = Director.new
scene = SCENE::GAME

Window.load_resources do
  Window.bgcolor = C_BLACK
  manturn = BLACK_TURN
  director.initGrp
  director.initSE

  Window.loop do
    case scene
    when SCENE::TITLE
      director.title
    when SCENE::GAME
      director.game
    end
    Window.draw_font(0, 0, "hello #{B}", Font.default, color: C_WHITE)
  end
end

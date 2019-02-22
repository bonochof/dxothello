require 'dxopal'
include DXOpal

require_remote "menu.rb"
require_remote "header.rb"
require_remote "position.rb"
require_remote "othello.rb"
require_remote "director.rb"

$scene = SCENE::TITLE
director = Director.new
Image.register(:title_back, './data/graphics/title.jpg')
Image.register(:game_back, './data/graphics/back.jpg')
Image.register(:menu0, './data/graphics/menu0.png')
Image.register(:menu1, './data/graphics/menu1.png')
Image.register(:menu2, './data/graphics/menu2.png')
Image.register(:menu3, './data/graphics/menu3.png')
Sound.register(:next, './data/sounds/next.wav')
Sound.register(:put_com, './data/sounds/putCOM.wav')
Sound.register(:put_man, './data/sounds/putMAN.wav')
Sound.register(:win, './data/sounds/win.wav')

Window.load_resources do
  Window.bgcolor = C_BLACK
  manturn = BLACK_TURN

  Window.loop do
    case $scene
    when SCENE::TITLE
      director.title
    when SCENE::GAME
      director.game
    end
  end
end

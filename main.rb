require 'dxopal'
include DXOpal

require_remote "header.rb"
require_remote "position.rb"
require_remote "othello.rb"

Window.load_resources do
  Window.bgcolor = C_BLACK

  Window.loop do
    Window.draw_font(0, 0, "hello #{B}", Font.default, color: C_WHITE)
  end
end

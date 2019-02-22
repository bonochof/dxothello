class Menu < Sprite
  def initialize (x, y, str, size, bias=0)
    font = Font.new(size, "Consolas")
    img = Image.new(str.size * size + bias, size + 50)
    img.box_fill(0, 0, img.width, img.height, C_BLACK)
    img.draw_font(20, 20, str, font, C_WHITE)
    super(x, y, img)
  end
end

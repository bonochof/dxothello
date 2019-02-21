class Menu < Sprite
  def initialize (x, y, str, size)
    font = Font.new(size)
    img = Image.new(str.size * size, size)
    img.draw_font(0, 0, str, font, C_BLACK)
    super(x, y, img)
  end
end

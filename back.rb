class Back
    def initialize(window)
        @image = Gosu::Image.new("media/Space.png")
        @x = @y = 0.0
    end

    def draw(x, y)
        @image.draw(x, y, 0)
    end

end
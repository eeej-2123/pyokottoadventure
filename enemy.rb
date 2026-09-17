class Enemy
    def initialize(window)
        @tiles = {
            1 => Gosu::Image.new("media/enemy/enemy1.png")
            2 => Gosu::Image.new("media/enemy/enemy2.png")
            3 => Gosu::Image.new("media/enemy/enemy3.png")
            4 => Gosu::Image.new("media/enemy/enemy4.png")
            5 => Gosu::Image.new("media/enemy/enemy5.png")
        }
    end



    def draw
    end
end
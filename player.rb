class Player
    def initialize(window)
        @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def move_left #左移動
        @vel_x = -5
    end

    def move_right #右移動
        @vel_x = 5
    end

    def move_up #上移動
        @vel_y = -20
    end

    def down #下移動
        if @y < 350
        @vel_y += 1
        end
        if @y >= 350 && @vel_y > 0
        @vel_y = 0
        end
    end

    def move
        @x += @vel_x
        @y += @vel_y

        @vel_x *= 0.95
        @vel_y *= 0.95
    end

    def draw
        @image.draw(@x, @y, 1)
    end

end
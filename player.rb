class Player
    def initialize(window)
        @image = Array.new(4)
        @image[0] = Gosu::Image.new("media/usagi1.png")
        @image[1] = Gosu::Image.new("media/usagi2.png")
        @image[2] = Gosu::Image.new("media/usagi3.png")
        @image[3] = Gosu::Image.new("media/usagi4.png")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @image_index = 0
        @image_wait = 0
        @image_angle = 1
        @score = 0
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def move_left #左移動
        @vel_x = -3
        @image_angle = -1
    end

    def move_right #右移動
        @vel_x = 3
        @image_angle = 1
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
        @image_wait += 1

        if @image_index == 3
            @image_index = 0
        end

        if @vel_x != 0 && @image_wait > 8
            @image_index += 1
            @image_wait = 0
        elsif @vel_x == 0
            @image_index = 3
        end

        @vel_x = 0
        @vel_y *= 0.95
    end

    def draw
        @image[@image_index].draw(@x, @y, 1, @image_angle, 1)
    end

end
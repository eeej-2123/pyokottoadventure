require_relative 'back'

class Player
    def initialize(window)
        @image = Array.new(4)
        @image[0] = Gosu::Image.new("media/usagi/usagi1.png")
        @image[1] = Gosu::Image.new("media/usagi/usagi2.png")
        @image[2] = Gosu::Image.new("media/usagi/usagi3.png")
        @image[3] = Gosu::Image.new("media/usagi/usagi4.png")
        @x = @y = @vel_x = @vel_y = 0.0
        @bx = 0.0
        @image_index = 0
        @image_wait = 0
        @image_angle = 1
        @score = 0
        @back = Back.new(self)
    end

    def warp(x, y)
        @x, @y = x, y
    end

    def move_left #左移動
        @vel_x = -5
        @image_angle = -1
    end

    def move_right #右移動
        @vel_x = 5
        @image_angle = 1
    end

    def move_up #上移動
        @vel_y = -20
    end

    def down #下移動

        if @y < 280
        @vel_y += 1
        end
        if @y >= 280 && @vel_y > 0
        @vel_y = 0
        end
    end

    def move
        if @bx==0 && @x <= 320 || @bx== -59*50+640 && @x >= 310
            @x += @vel_x
        else
            @bx -= @vel_x
            @x=320
        end
        
        @y += @vel_y
        @image_wait += 1

        if @image_index == 3
            @image_index = 0
        end

        if @vel_y != 0
            @image_index = 2
        elsif @vel_x != 0 && @image_wait > 6
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
        @back.draw(@bx, 0)
    end

end
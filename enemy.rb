class Enemy
    def initialize(window)
        @enemy = Array.new(5)
        @enemy[0] = Gosu::Image.new("media/enemy/enemy1.png")
        @enemy[1] = Gosu::Image.new("media/enemy/enemy2.png")
        @enemy[2] = Gosu::Image.new("media/enemy/enemy3.png")
        @enemy[3] = Gosu::Image.new("media/enemy/enemy4.png")
        @enemy[4] = Gosu::Image.new("media/enemy/enemy5.png")

        @image_angle = -1
        @image_index = 0
        @x = @y = 0
        @enemy_move=0
        @image_wait = 0
    end

    CHAR_WIDTH = 50   # キャラクターの幅(実際の画像サイズに合わせて調整)
    CHAR_HEIGHT = 50  # キャラクターの高さ(実際の画像サイズに合わせて調整)

    def warp(x,y)
        @x = x
        @y = y
    end

    def move_enemy
        @image_wait += 1
        if @enemy_move < 100
            @enemy_move += 1
            @x += @image_angle*2
            if @image_index < 3
                if @image_wait > 20
                    @image_index += 1
                    @image_wait = 0
                end
            else
                @image_index = 0
            end
        else
            @enemy_move = 0
            @image_angle *= -1
        end
    end

    def draw(x,y)
        if @image_angle == -1
            @enemy[@image_index].draw(@x + CHAR_WIDTH + x, @y + y, 1, @image_angle, 1)
        else
            @enemy[@image_index].draw(@x + x, @y + y, 1, @image_angle, 1)
        end
    end
end
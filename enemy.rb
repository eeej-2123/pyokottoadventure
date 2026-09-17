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
        @enemy_move = 0
        @image_wait = 0

        @state = :alive   # :alive → :dying → :dead
        @dying_wait = 0
        @dying_time = 30  # 何フレーム表示してから消すか(30なら約0.5秒)
    end

    CHAR_WIDTH = 50
    CHAR_HEIGHT = 50

    def get_x
        @x
    end

    def get_y
        @y
    end

    def alive?
        @state == :alive
    end

    def dead?
        @state == :dead
    end

    def defeat
        return unless @state == :alive
        @state = :dying
        @image_index = 4   # 倒れた画像に切り替え
        @dying_wait = 0
    end

    def warp(x, y)
        @x = x
        @y = y
    end

    def move_enemy
        case @state
        when :alive
            @image_wait += 1
            if @enemy_move < 100
                @enemy_move += 1
                @x += @image_angle * 2
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

        when :dying
            @dying_wait += 1
            if @dying_wait >= @dying_time
                @state = :dead
            end
        end
    end

    def draw(x, y)
        return if @state == :dead   # 完全に消えたら描画しない

        if @image_angle == -1
            @enemy[@image_index].draw(@x + CHAR_WIDTH + x, @y + y, 1, @image_angle, 1)
        else
            @enemy[@image_index].draw(@x + x, @y + y, 1, @image_angle, 1)
        end
    end
end
class Enemy
    def initialize(window, back)
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

        @state = :alive
        @dying_wait = 0
        @dying_time = 30

        @back = back   # ← タイル判定用に受け取る
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
        @image_index = 4
        @dying_wait = 0
    end

    def warp(x, y)
        @x = x
        @y = y
    end

    # 進行方向の壁チェック
    def check_wall
        check_x = @image_angle == 1 ? @x + CHAR_WIDTH + 1 : @x - 1
        top_y    = @y
        bottom_y = @y + CHAR_HEIGHT - 15

        tile_top    = @back.check_tile(check_x, top_y)
        tile_bottom = @back.check_tile(check_x, bottom_y)

        (!tile_top.nil? && tile_top != 0) || (!tile_bottom.nil? && tile_bottom != 0)
    end

    # 進行方向の足元(地面があるか)チェック
    def check_ground
        foot_y = @y + CHAR_HEIGHT*2 + 1
        check_x = @image_angle == 1 ? @x + CHAR_WIDTH - 1 : @x + 1

        tile = @back.check_tile(check_x, foot_y)

        tile.nil? || tile == 0   # true = 地面がない(崖)
    end

    def move_enemy
        case @state
        when :alive
            @image_wait += 1

            if check_wall || check_ground
                @image_angle *= -1   # 反転
            else
                @x += @image_angle * 2
            end

            if @image_index < 3
                if @image_wait > 20
                    @image_index += 1
                    @image_wait = 0
                end
            else
                @image_index = 0
            end

        when :dying
            @dying_wait += 1
            if @dying_wait >= @dying_time
                @state = :dead
            end
        end
    end

    def draw(x, y)
        return if @state == :dead

        if @image_angle == -1
            @enemy[@image_index].draw(@x + CHAR_WIDTH + x, @y + y, 1, @image_angle, 1)
        else
            @enemy[@image_index].draw(@x + x, @y + y, 1, @image_angle, 1)
        end
    end
end
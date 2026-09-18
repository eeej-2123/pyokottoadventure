require_relative 'back'

class Player
    def initialize(window)
        @image = Array.new(4)
        @image[0] = Gosu::Image.new("media/usagi/usagi1.png")
        @image[1] = Gosu::Image.new("media/usagi/usagi2.png")
        @image[2] = Gosu::Image.new("media/usagi/usagi3.png")
        @image[3] = Gosu::Image.new("media/usagi/usagi4.png")
        @heart=Gosu::Image.new("media/usagi/heart.png")
        @x = @y = @vel_x = @vel_y = 0.0
        @bx = 0.0
        @image_index = 0
        @image_wait = 0
        @image_angle = 1
        @score = 0
        @life=3
        @back = Back.new(self)
    end

    def get_back_obj
        @back
    end

    def get_x
        return @x
    end

    def get_y
        return @y
    end

    def get_back
        return @bx
    end

    def get_life
        return @life
    end

    def get_vel_y
    @vel_y
    end

    def set_back
        @bx=0
    end

    def warp(x, y)
        @x, @y = x, y
    end

    CHAR_WIDTH = 50   # キャラクターの幅(実際の画像サイズに合わせて調整)
    CHAR_HEIGHT = 50  # キャラクターの高さ(実際の画像サイズに合わせて調整)

    def bounce
        @vel_y = -10
    end

    def move_left #左移動
        @check_x = @x - @bx + 1        # 左端のさらに1px先
        @top_y    = @y
        @bottom_y = @y + CHAR_HEIGHT - 15

        @tile_top    = @back.check_tile(@check_x, @top_y)
        @tile_bottom = @back.check_tile(@check_x, @bottom_y)

        @blocked = (!@tile_top.nil? && @tile_top != 0) || (!@tile_bottom.nil? && @tile_bottom != 0)

        unless @blocked
            @vel_x = -5
            @image_angle = -1
        end

        if @x==5
            @vel_x=0
        end
    end

    def move_right #右移動
        @check_x = @x - @bx + CHAR_WIDTH + 1   # 右端のさらに1px先
        @top_y    = @y
        @bottom_y = @y + CHAR_HEIGHT - 15

        @tile_top    = @back.check_tile(@check_x, @top_y)
        @tile_bottom = @back.check_tile(@check_x, @bottom_y)

        @blocked = (!@tile_top.nil? && @tile_top != 0) || (!@tile_bottom.nil? && @tile_bottom != 0)

        unless @blocked
            @vel_x = 5
            @image_angle = 1
        end

        if @x==640-50
            @vel_x=0
        end
    end

    def move_up(pressed) #上移動(ジャンプ開始)
        if @vel_y == 0
            pressed = 0
        end
        if pressed < 2
            @vel_y = -20
            pressed += 1
        end
        return pressed
    end

    # 上から触れると危険なタイル(足元に生えている棘など)
    HAZARD_TOP = [7, 12]
    # 下から触れると危険なタイル(天井に生えている棘など)
    HAZARD_BOTTOM = [11, 13]

    def check_hazard
        left_x  = @x - @bx
        right_x = @x - @bx + 40      # down と同じ基準に合わせる

        # 足元(上から乗った)判定
        foot_y = @y + 70             # down と同じ基準に合わせる
        tile_left_foot  = @back.check_tile(left_x,  foot_y)
        tile_right_foot = @back.check_tile(right_x, foot_y)

        return true if HAZARD_TOP.include?(tile_left_foot) || HAZARD_TOP.include?(tile_right_foot)

        # 頭上(下から触れた)判定
        head_y = @y - 1
        tile_left_head  = @back.check_tile(left_x,  head_y)
        tile_right_head = @back.check_tile(right_x, head_y)

        return true if HAZARD_BOTTOM.include?(tile_left_head) || HAZARD_BOTTOM.include?(tile_right_head)

        false
    end

    def check_ceiling #天井の当たり判定(毎フレーム呼ぶ)
        return unless @vel_y < 0   # 上昇中でなければ何もしない

        @check_y = @y - 1
        @left_x  = @x - @bx
        @right_x = @x - @bx + CHAR_WIDTH - 1

        @tile_left  = @back.check_tile(@left_x,  @check_y)
        @tile_right = @back.check_tile(@right_x, @check_y)

        @blocked = (!@tile_left.nil? && @tile_left != 0) || (!@tile_right.nil? && @tile_right != 0)

        if @blocked
            @vel_y = 0   # ぶつかったら上昇を止める(すぐ落下に転じる)
        end
    end

    def down #下移動
        @foot_y = @y + 70          # 足元のY座標
        @left_x  = @x - @bx        # キャラクター左端
        @right_x = @x - @bx + 40   # キャラクター右端(幅は仮に40px。実際の画像幅に合わせて調整)

        @tile_left  = @back.check_tile(@left_x,  @foot_y)
        @tile_right = @back.check_tile(@right_x, @foot_y)

        if (@tile_left.nil? || @tile_left == 0) && (@tile_right.nil? || @tile_right == 0)
            # 足元に何もない → 落下継続
            @vel_y += 1
        elsif @vel_y > 0
            # 落下中に着地 → タイルの上面にぴったり合わせる
            @vel_y = 0
            @y = ((@foot_y / 50).to_i * 50) - 70
        end
    end

    def down_life
        @life -= 1
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
        if @image_angle == -1
            @image[@image_index].draw(@x + CHAR_WIDTH, @y, 1, @image_angle, 1)
        else
            @image[@image_index].draw(@x, @y, 1, @image_angle, 1)
        end
        @back.draw(@bx, 0)

        for i in 0..@life - 1
            @heart.draw(i * 80,0)
        end
    end
end
require_relative 'back'

class Player
    def initialize(window)
        @image = Array.new(4)
        @image[0] = Gosu::Image.new("media/usagi/usagi1.png")
        @image[1] = Gosu::Image.new("media/usagi/usagi2.png")
        @image[2] = Gosu::Image.new("media/usagi/usagi3.png")
        @image[3] = Gosu::Image.new("media/usagi/usagi4.png")
        @heart=Gosu::Image.new("media/usagi/heart.png")

        @se_jump = Gosu::Sample.new("bgm/junp.mp3")
        @se_get = Gosu::Sample.new("bgm/get.mp3")
        @se_drop = Gosu::Sample.new("bgm/drop.mp3")
        @se_run = Gosu::Sample.new("bgm/run.mp3")
        @se_coin = Gosu::Sample.new("bgm/coin.mp3")

        @x = @y = @vel_x = @vel_y = 0.0
        @bx = 0.0
        @image_index = 0
        @image_wait = 0
        @image_angle = 1
        @score = 0
        @life=3
        @back = Back.new(self)
        @dying = false
        @clearing = false
        @allclearing = false
        @sound_size = 100
        @run_wait=0
    end

    def set_life
        @life=3
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
        @vel_x = @vel_y = 0.0
        @image_angle = 1
    end

    def dying?
        @dying
    end

    def die #死亡演出を開始(その場で少し跳ねる)
        @dying = true
        @vel_x = 0
        @vel_y = -15   # 上に少し跳ねる強さ(お好みで調整)
        @se_drop.play(@sound_size)
    end

    def update_dying #死亡演出中の落下(毎フレーム)
        @vel_y += 1     # 重力
        @y += @vel_y
    end

    def dying_finished? #画面外まで落ちたか
        @y > 480 + 50   # 画面の高さ+余白まで落ちたら終了
    end

    def end_dying
        @dying = false
    end

    def clearing?
        @clearing
    end

    def clear 
        @clearing = true
        @image_angle = 1
        @se_get.play(@sound_size)
    end

    def update_clearing
        @image_angle *= -1
    end

    def clearing_finished? 
        @x > 640 + 100   
    end

    def end_clearing
        @clearing = false
    end


    CHAR_WIDTH = 50   # キャラクターの幅(実際の画像サイズに合わせて調整)
    CHAR_HEIGHT = 50  # キャラクターの高さ(実際の画像サイズに合わせて調整)

    def bounce
        @vel_y = -10
    end

    def move_left #左移動(速度をセットするだけ)
        @vel_x = -5
        @image_angle = -1
    end

    def move_right #右移動(速度をセットするだけ)
        @vel_x = 5
        @image_angle = 1
    end

    def check_wall_x #横方向の壁判定(毎フレーム呼ぶ)
        return if @vel_x == 0

        top_y    = @y + 2
        bottom_y = @y + CHAR_HEIGHT - 15

        if @vel_x < 0
            check_x = @x - @bx + @vel_x

            tile_top    = @back.check_tile(check_x, top_y)
            tile_bottom = @back.check_tile(check_x, bottom_y)

            blocked = (!tile_top.nil? && tile_top != 0) || (!tile_bottom.nil? && tile_bottom != 0)

            if blocked
                tile_x = (check_x / 50).to_i
                @x = (tile_x + 1) * 50 + @bx
                @vel_x = 0
            end

        elsif @vel_x > 0
            check_x = @x - @bx + CHAR_WIDTH + @vel_x

            tile_top    = @back.check_tile(check_x, top_y)
            tile_bottom = @back.check_tile(check_x, bottom_y)

            blocked = (!tile_top.nil? && tile_top != 0) || (!tile_bottom.nil? && tile_bottom != 0)

            if blocked
                tile_x = (check_x / 50).to_i
                @x = tile_x * 50 - CHAR_WIDTH + @bx
                @vel_x = 0
            end
        end

        # 画面端のチェック(タイルの壁判定とは別に、常に効かせる)
        if @x + @vel_x <= 0
            @x = 0
            @vel_x = 0
        elsif @x + @vel_x >= 640 - CHAR_WIDTH
            @x = 640 - CHAR_WIDTH
            @vel_x = 0
        end
    end

    def move_up(pressed) #上移動(ジャンプ開始)
        if @vel_y == 0
            pressed = 0
        end
        if pressed < 2
            @se_jump.play(@sound_size)
            @vel_y = -20
            pressed += 1
        end
        return pressed
    end

    def trap_up
        @vel_y = -50
    end

    def passed_x?(x) # 進行方向の先端が指定x座標(ワールド座標)を通り過ぎたらtrue
        world_x = @x - @bx   # スクロールを考慮したワールド座標

        if @image_angle == 1 
            # 右向き:右端が指定x座標を超えたら
            world_x + CHAR_WIDTH == x
        elsif @image_angle == -1
            world_x == x
        end
    end

    # 上から触れると危険なタイル(足元に生えている棘など)
    HAZARD_TOP = [7, 12, 15, 16]
    # 下から触れると危険なタイル(天井に生えている棘など)
    HAZARD_BOTTOM = [11, 13]

    def check_hazard
        left_x  = @x - @bx + 5
        right_x = @x - @bx + 40      # down と同じ基準に合わせる

        # 足元(上から乗った)判定
        foot_y = @y + 70             # down と同じ基準に合わせる
        tile_left_foot  = @back.check_tile(left_x,  foot_y)
        tile_right_foot = @back.check_tile(right_x, foot_y)

        return true if HAZARD_TOP.include?(tile_left_foot) || HAZARD_TOP.include?(tile_right_foot)

        # 頭上(下から触れた)判定
        head_y = @y - 10
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

    STAGE_RIGHT_LIMIT = -59 * 50 + 640   # ステージ右端でのbxの値
    STAGE_LEFT_LIMIT = 0
    
    def move
        if @bx==0 && @x <= 320 || @bx== -59*50+640 && @x >= 310
            @x += @vel_x
        else
            @bx -= @vel_x
            @x=320
        end

        # ステージ右端を超えないようにガード
        if @bx < STAGE_RIGHT_LIMIT
            @bx = STAGE_RIGHT_LIMIT
        end

        if @bx > STAGE_LEFT_LIMIT
            @bx = STAGE_LEFT_LIMIT
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
            if @run_wait==0
            @se_run.play(@sound_size)
            @run_wait = 3
            else
                @run_wait -= 1
            end
        elsif @vel_x == 0
            @image_index = 3
        end

        if @back.get_stagemum == 4
            @vel_x*=0.95
            if @image_angle == 1
                if @vel_x < 0.01
                    @vel_x = 0
                end
            end
            if @image_angle == -1
                if @vel_x > -0.01
                    @vel_x = 0
                end
            end
        else
            @vel_x = 0
        end
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
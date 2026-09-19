require 'gosu'
require_relative 'player'
require_relative 'gameover'
require_relative 'clear'
require_relative 'start'
require_relative 'enemy'
require_relative 'back'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "ピョコっとアドベンチャー"
    @enemy=Array.new(3)
    #@image = Gosu::Image.new("media/Space.png")
    @player = Player.new(self)
    @gameover = Gameover.new(self)
    @clear = Clear.new(self)
    @start = Start.new(self)
    @back = @player.get_back_obj

    for i in 0..2 do
      @enemy[i]=Enemy.new(self, @player.get_back_obj)
    end

    @scleen_num=0
    @player.warp(20, 330)
    @outed = 1
    @up_pressed = 0
    @cleared = 0
    @fleem = 0
    @traped = 0
  end

  def update
    if @scleen_num == 0
      if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
        @start.change_mode(0)
      end
      if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
        @start.change_mode(1)
      end
      if button_down? Gosu::KbUp then
        @start.change_mode(2)
      end
      if button_down? Gosu::KbDown then
        @start.change_mode(3)
      end
    end

    if @scleen_num == 1 && @outed == 0
      if @player.clearing?
        @fleem+=1
        if @fleem >= 120
          @player.move_right
          @player.move
          if @player.clearing_finished?
            @back.stop_bgm(@scleen_num)
            @back.change_stage
            @fleem = 0
            if @back.get_stagemum != 6
              @cleared = 1
              @player.warp(20, 330)
              enemy_warp
            else
              @player.warp(-40,330)
            end
            @player.set_back
            @clear.reset
            @player.end_clearing
            @back.start_bgm(@scleen_num)
          end
        elsif @fleem % 30 == 0 && @fleem > 0
            @player.update_clearing
        else
            @player.down
            @player.move
        end
        
      elsif @player.dying?
        # 死亡演出中:通常操作・当たり判定はせず、落下だけ進める
        @player.update_dying

        if @player.dying_finished?
          @player.end_dying
          @player.warp(20, 330)
          @player.set_back
          enemy_warp
          @outed = 1
          @fleem = 0
          @back.stop_bgm(@scleen_num)
        end

      elsif @back.get_stagemum == 6  
        @fleem+=1
        if @fleem < 40 
          @player.move_right
          @player.move
        elsif @fleem < 80
          if @fleem == 40
            @up_pressed = @player.move_up(@up_pressed)
          else
            @player.down
          end
          @player.move
        elsif@fleem < 120
          if @fleem == 80
            @up_pressed = @player.move_up(@up_pressed)
          else
            @player.down
          end
          @player.move
        else
          if button_down? Gosu::KB_RETURN then
            @scleen_num=0
            @player.warp(20, 330)
            @outed = 1
            @up_pressed = 0
            @cleared = 0
            @fleem = 0
            @traped = 0
            @clear.reset
            @back.set
            enemy_warp
            @player.set_life
          end
        end
      else
        # 通常時の処理(今まで通り)
        if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
          @player.move_left
        end
        if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
          @player.move_right
        end

        @player.down
        @player.check_ceiling
        @player.check_wall_x
        @player.move
        if @back.get_stagemum !=5
          @enemy[0].move_enemy
          @enemy[1].move_enemy
          @enemy[2].move_enemy
          check_enemy_collision(0)
          check_enemy_collision(1)
          check_enemy_collision(2)
        end

        if @back.get_stagemum==3
          if @player.passed_x?(50*40) && @traped==0
            @traped=1
            @back.change_tile
          end
          if @player.passed_x?(50*49+25) && @player.get_vel_y == 0
            @player.trap_up
          end
        end

        if @player.check_hazard
          @player.down_life
          @player.die          # ← 即warpではなく死亡演出を開始
        end

        if @gameover.gameover(@player.get_x, @player.get_y)
          @player.down_life
          @player.die          # ← 同上
        end

        if @clear.check_clear(@player.get_x - @player.get_back, @player.get_y) && @cleared==0
          @player.clear
        end
      end
    end
    if @scleen_num == 2
    end
    if @scleen_num == 3
    end

  end

  def enemy_warp
    if @back.get_stagemum==1
          @enemy[0].warp(11*50, 7*50-20)
          @enemy[1].warp(40*50, 7*50-20)
          @enemy[2].warp(54*50, 7*50-20)
        elsif @back.get_stagemum==2
          @enemy[0].warp(8*50, 7*50-20)
          @enemy[1].warp(18*50, 0*50-20)
          @enemy[2].warp(45*50, 4*50-20)
        elsif @back.get_stagemum==3
          @enemy[0].warp(15*50, 4*50-20)
          @enemy[1].warp(35*50, 7*50-20)
          @enemy[2].warp(53*50, 4*50-20)
        elsif @back.get_stagemum==4
          @enemy[0].warp(5*50, 3*50-20)
          @enemy[1].warp(18*50, 7*50-20)
          @enemy[2].warp(47*50, 7*50-20)
        end
  end

  def button_down(id)
    if @scleen_num == 0
      if id == Gosu::KB_RETURN
        @scleen_num = @start.selected
        enemy_warp
      end
    elsif @scleen_num == 1
      if id == Gosu::KbUp
        @up_pressed = @player.move_up(@up_pressed)
      end
    elsif @scleen_num == 2
      if id == Gosu::KB_RETURN
        @scleen_num = 0
      end
    elsif @scleen_num == 3
      if id == Gosu::KB_RETURN
        @scleen_num = 0
      end
    end
    if id == Gosu::KbEscape
      close
    end
  end

  def check_enemy_collision(i)
    return unless @enemy[i].alive?

    px = @player.get_x - @player.get_back
    py = @player.get_y
    pw = Player::CHAR_WIDTH
    ph = Player::CHAR_HEIGHT

    ex = @enemy[i].get_x
    ey = @enemy[i].get_y
    ew = Enemy::CHAR_WIDTH
    eh = Enemy::CHAR_HEIGHT

    # 重なっているか(AABB判定)
    overlap = px < ex + ew && px + pw > ex && py < ey + eh && py + ph > ey
    return unless overlap

    # それぞれの軸での重なりの深さを計算
    overlap_x = [px + pw, ex + ew].min - [px, ex].max
    overlap_y = [py + ph, ey + eh].min - [py, ey].max

    if overlap_y < overlap_x && py < ey && @player.get_vel_y > 0
        # 縦方向の重なりが浅く、プレイヤーが上にいて落下中 → 上から踏んだ
        @enemy[i].defeat
        @player.bounce   # 任意:踏んだ時に少し跳ねさせる
    else
        # それ以外 → 横からぶつかった → 死亡演出を開始
        @player.down_life
        @player.die
    end
  end

  def draw
    if @scleen_num == 0
      @start.draw
    end

    if @scleen_num == 1
      if @outed == 1 || @cleared == 1
        @gameover.draw(@player.get_life, @back.get_stagemum)
        @fleem += 1
        if @fleem == 50
          @outed = 0
          @cleared = 0
          @fleem = 0
        end
        @back.start_bgm(@scleen_num)
      else
        @player.draw
        @clear.draw(@player.get_back, 0)
        if @back.get_stagemum < 5
          @enemy[0].draw(@player.get_back, 0)
          @enemy[1].draw(@player.get_back, 0)
          @enemy[2].draw(@player.get_back, 0)
        # Drawing code goes here
        end
      end
    end
    if @scleen_num == 2
      @start.draw_settei
    end
    if @scleen_num == 3
      @start.draw_sousa
    end
  end
end

window = GameWindow.new
window.show
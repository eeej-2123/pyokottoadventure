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

    #@image = Gosu::Image.new("media/Space.png")
    @player = Player.new(self)
    @gameover = Gameover.new(self)
    @clear = Clear.new(self)
    @start = Start.new(self)
    @enemy = Enemy.new(self, @player.get_back_obj)
    @back = Back.new(self)

    @scleen_num=0
    @player.warp(20, 240)
    #@enemy.warp(18*50, 6*50-20)
    @outed = 1
    @up_pressed = 0
    @cleared = 0
    @fleem = 0
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
      if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
        @player.move_left
      end
      if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
        @player.move_right
      end
      # Game logic goes here
      @player.down
      @player.check_ceiling
      @player.move
      @enemy.move_enemy
      #check_enemy_collision

      if @gameover.gameover(@player.get_x, @player.get_y)
        @player.warp(20, 240)
        @player.set_back
        @player.down_life
        @outed=1
      end

      if @clear.check_clear(@player.get_x - @player.get_back, @player.get_y) && @cleared==0
        @cleared = 1
      end

      if @cleared == 1
        @fleem+=1
        if @fleem == 40
          if !@back.change_stage
            continue
          end
          @cleared = 2
          @fleem = 0
          @player.warp(20, 240)
          @player.set_back
          @clear.reset
        end
      end
    end
    if @scleen_num == 2
    end
    if @scleen_num == 3
    end


  end

  def button_down(id)
  if @scleen_num == 0
    if id == Gosu::KB_RETURN
      @scleen_num = @start.selected
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

  def check_enemy_collision
    return unless @enemy.alive?

    px = @player.get_x - @player.get_back
    py = @player.get_y
    pw = Player::CHAR_WIDTH
    ph = Player::CHAR_HEIGHT

    ex = @enemy.get_x
    ey = @enemy.get_y
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
        @enemy.defeat
        @player.bounce   # 任意:踏んだ時に少し跳ねさせる
    else
        # それ以外 → 横からぶつかった → ゲームオーバー扱い
        @player.warp(20, 240)
        @player.set_back
        @player.down_life
        @outed = 1
    end
  end

  def draw
    if @scleen_num == 0
      @start.draw
    end

    if @scleen_num == 1
      if @outed == 1 || @cleared == 2
        @gameover.draw(@player.get_life)
        @fleem += 1
        if @fleem == 50
          @outed = 0
          @cleared = 0
          @fleem = 0
        end
      else
        @player.draw
        @clear.draw(@player.get_back, 0)
        #@enemy.draw(@player.get_back, 0)
        # Drawing code goes here
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
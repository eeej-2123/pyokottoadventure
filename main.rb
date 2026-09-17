require 'gosu'
require_relative 'player'
require_relative 'gameover'
require_relative 'clear'
require_relative 'start'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "ピョコっとアドベンチャー"

    #@image = Gosu::Image.new("media/Space.png")
    @player = Player.new(self)
    @gameover = Gameover.new(self)
    @clear = Clear.new(self)
    @start = Start.new(self)

    @scleen_num=0
    @player.warp(20, 240)
    @up_pressed = 0
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
      if button_down? (Gosu::KB_RETURN) then
        @scleen_num = @start.selected
      end
    end

    if @scleen_num == 1
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

      if @gameover.gameover(@player.get_x, @player.get_y)
        @player.warp(20, 240)
        @player.set_back
        @player.down_life
      end

      if @clear.check_clear(@player.get_x - @player.get_back, @player.get_y)
      
      end
    end


  end

  def button_down(id)
    if id == Gosu::KbUp
      @up_pressed = @player.move_up(@up_pressed)
    end
    
    if id == Gosu::KbEscape
        close
    end
  end

  def draw
    if @scleen_num == 0
      @start.draw
    end

    if @scleen_num == 1
      @player.draw
      @clear.draw(@player.get_back, 0)
      # Drawing code goes here
    end
  end
end

window = GameWindow.new
window.show
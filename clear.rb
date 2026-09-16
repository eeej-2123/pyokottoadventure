class Clear
    def initialize(window)
        @goal = Gosu::Image.new("media/ninjin.png")
        @x = 57.5*50
        @y = 4*50
        @isCleared = false
    end

    def check_clear(x, y) #ゴールの判定(x, yはピクセル座標)
        if (x+50 >= @x && x <= @x+50) && (y+50 >= @y && y <= @y+50)
            @isCleared = true
        end 
        return @isCleared
    end

    def draw(x, y) #ゴールの描画
        if !@isCleared
            @goal.draw(@x+x, @y+y, 1)
        end
    end
end
class Gameover
    def initialize(window)
        @font = Gosu::Font.new(30)  # 30はフォントサイズ
        @life = Gosu::Image.new("media/usagi/heart.png")
        @back = Gosu::Image.new("media/back/life.png")
    end

    def gameover(x, y) #ゲームオーバーの判定(x, yはピクセル座標)
        if y >= 480
            return true
        end
        return false
    end

    def draw(life) #ゲームオーバーの描画
       @back.draw(0,0,0)
       @life.draw(220,240-37.5,0)
       @font.draw_text("×#{life}", 320, 240-30, 0, 2, 2, Gosu::Color::WHITE)
    end
end
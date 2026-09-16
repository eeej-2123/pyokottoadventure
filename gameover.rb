class Gameover
    def initialize(window)
    end

    def gameover(x, y) #ゲームオーバーの判定(x, yはピクセル座標)
        if y >= 480
            return true
        end
        return false
    end

    def draw(x, y) #ゲームオーバーの描画
       
    end
end
class Back
    def initialize(window)
        @image = Array.new(5)
        @image[0] = Gosu::Image.new("media/back/Sora.png")
        @image[1] = Gosu::Image.new("media/back/Sora.png")
        @image[2] = Gosu::Image.new("media/back/Sora.png")
        @image[3] = Gosu::Image.new("media/back/Sora.png")
        @image[4] = Gosu::Image.new("media/back/Sora.png")

        @x = @y = 0.0
        @xmax = 59
        @ymax = 9
        @stagemum = 1

        input_back    # マップとタイル画像はinitializeで一度だけ読み込む
        input_tiles
    end

    def input_back #背景配置の読み込み
        @map = File.readlines("media/map/1-1.txt").map do |line|
            line.split.map(&:to_i)
        end
    end

    def change_stage
        if @stagemum < 5
           @stagemum += 1
           return true
        else
            return false
        end
    end


    def input_tiles #タイル画像の読み込み
        @tiles = {
            1 => Gosu::Image.new("media/tiles1-1/kusa.png"),
            2 => Gosu::Image.new("media/tiles1-1/tuti.png"),
            3 => Gosu::Image.new("media/tiles1-1/renga.png"),
            4 => Gosu::Image.new("media/tiles1-1/brock.png"),
            5 => Gosu::Image.new("media/tiles1-1/hatena.png")
        }
    end

    def check_tile(x, y) #タイルの判定(x, yはピクセル座標)
        tile_x = (x / 50).to_i
        tile_y = (y / 50).to_i

        return nil if tile_y < 0 || tile_y >= @map.length
        return nil if tile_x < 0 || tile_x >= @map[tile_y].length

        return @map[tile_y][tile_x]
    end

    def draw(x, y) #背景の描画
        @image[0].draw(0, 0, -1)
        @map.each_with_index do |row, i|
            row.each_with_index do |tile_num, j|
                tile = @tiles[tile_num]
                next if tile.nil?
                tile.draw(x + j * 50, y + i * 50 - 20, 1)
            end
        end
    end
end
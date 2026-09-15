class Back
    def initialize(window)
        @image = Gosu::Image.new("media/Space.png")
        @x = @y = 0.0
        @xmax = 59
        @ymax = 9
    end

    def input_back #背景配置の読み込み
        @map = File.readlines("media/map/1-1.txt").map do |line|
            line.split.map(&:to_i)
        end
    end

    def input_tiles #タイル画像の読み込み
        @tiles = {
            1 => Gosu::Image.new("media/tiles/kusa.png"),
            2 => Gosu::Image.new("media/tiles/tuti.png"),
            3 => Gosu::Image.new("media/tiles/renga.png"),
            4 => Gosu::Image.new("media/tiles/brock.png"),
            5 => Gosu::Image.new("media/tiles/hatena.png")
        }
    end

    def check_tile(x, y) #タイルの判定
        tile_x = (x / 50).to_i
        tile_y = (y / 50).to_i
        if tile_x < 0 || tile_x >= @xmax || tile_y < 0 || tile_y >= @ymax
            return nil
        end
        @map[tile_y][tile_x]
    end
    

    def draw(x, y) #背景の描画
        input_back
        input_tiles
        @image.draw(x, y, -1)
        @map.each_with_index do |row, i|
            row.each_with_index do |tile_num, j|
                @tile = @tiles[tile_num]
                next if @tile.nil?  # 対応する画像がなければスキップ
                @tile.draw(x+j * 50, y+i * 50-20, 1)
            end
        end
    end

end
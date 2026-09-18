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
        @stagemum = 3

        input_back    # マップとタイル画像はinitializeで一度だけ読み込む
        input_tiles
    end

    def get_stagemum
        return @stagemum
    end

    def change_tile
        for i in 6..9
            for j in 37..39
                @map2[i][j] = @map2[i][j+5]
                @map2[i][j+5] = 0
            end
        end
    end
    
    def input_back #背景配置の読み込み
        @map0 = File.readlines("media/map/1-1.txt").map do |line|
            line.split.map(&:to_i)
        end
        @map1 = File.readlines("media/map/1-2.txt").map do |line|
            line.split.map(&:to_i)
        end
        @map2 = File.readlines("media/map/1-3.txt").map do |line|
            line.split.map(&:to_i)
        end
        @map3 = File.readlines("media/map/1-4.txt").map do |line|
            line.split.map(&:to_i)
        end
        @map4 = File.readlines("media/map/1-5.txt").map do |line|
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
            5 => Gosu::Image.new("media/tiles1-1/hatena.png"),
            6 => Gosu::Image.new("media/tiles1-2/iron.png"),
            7 => Gosu::Image.new("media/tiles1-2/toge.png"),
            8 => Gosu::Image.new("media/tiles1-4/grass.png"),
            9 => Gosu::Image.new("media/tiles1-3/sand.png"),
            10 => Gosu::Image.new("media/tiles1-3/coin.png"),
            11 => Gosu::Image.new("media/tiles1-3/under_toge.png"),
            12 => Gosu::Image.new("media/tiles1-4/ice_toge_up.png"),
            13 => Gosu::Image.new("media/tiles1-4/ice_toge_down.png"),
            15 => Gosu::Image.new("media/tiles1-5/maguma.png"),
            14 => Gosu::Image.new("media/tiles1-5/redrenga.png"),
            16 => Gosu::Image.new("media/tiles1-5/redrenga.png"),
        }
    end

    def check_tile(x, y) #タイルの判定(x, yはピクセル座標)
        tile_x = (x / 50).to_i
        tile_y = (y / 50).to_i

        if @stagemum == 1
            return nil if tile_y < 0 || tile_y >= @map0.length
            return nil if tile_x < 0 || tile_x >= @map0[tile_y].length

            return @map0[tile_y][tile_x]
        elsif @stagemum == 2
            return nil if tile_y < 0 || tile_y >= @map1.length
            return nil if tile_x < 0 || tile_x >= @map1[tile_y].length

            return @map1[tile_y][tile_x]
        elsif @stagemum == 3
            return nil if tile_y < 0 || tile_y >= @map2.length
            return nil if tile_x < 0 || tile_x >= @map2[tile_y].length

            return @map2[tile_y][tile_x]
        elsif @stagemum == 4
            return nil if tile_y < 0 || tile_y >= @map3.length
            return nil if tile_x < 0 || tile_x >= @map3[tile_y].length

            return @map3[tile_y][tile_x]
        elsif @stagemum == 5
            return nil if tile_y < 0 || tile_y >= @map4.length
            return nil if tile_x < 0 || tile_x >= @map4[tile_y].length

            return @map4[tile_y][tile_x]
        end
    end

    def draw(x, y) #背景の描画
        @image[0].draw(0, 0, -1)
        if @stagemum == 1
            @map0.each_with_index do |row, i|
                row.each_with_index do |tile_num, j|
                    tile = @tiles[tile_num]
                    next if tile.nil?
                    tile.draw(x + j * 50, y + i * 50 - 20, 0)
                end
            end
        elsif @stagemum == 2
            @map1.each_with_index do |row, i|
                row.each_with_index do |tile_num, j|
                    tile = @tiles[tile_num]
                    next if tile.nil?
                    tile.draw(x + j * 50, y + i * 50 - 20, 0)
                end
            end
        elsif @stagemum == 3
            @map2.each_with_index do |row, i|
                row.each_with_index do |tile_num, j|
                    tile = @tiles[tile_num]
                    next if tile.nil?
                    tile.draw(x + j * 50, y + i * 50 - 20, 0)
                end
            end
        elsif @stagemum == 4
            @map3.each_with_index do |row, i|
                row.each_with_index do |tile_num, j|
                    tile = @tiles[tile_num]
                    next if tile.nil?
                    tile.draw(x + j * 50, y + i * 50 - 20, 0)
                end
            end
        elsif @stagemum == 5
            @map4.each_with_index do |row, i|
                row.each_with_index do |tile_num, j|
                    tile = @tiles[tile_num]
                    next if tile.nil?
                    tile.draw(x + j * 50, y + i * 50 - 20, 1)
                end
            end
        end
    end
end
class Back
    def initialize(window)
        @image = Gosu::Image.new("media/Space.png")
        @x = @y = 0.0
        @xmax = 60
        @ymax = 10
    end

    def input_back
        @map = File.readlines("media/map/1-1.txt").map do |line|
            line.split.map(&:to_i)
        end
    end

    def input_chip
        @tiles = {
            0 => nil,
            1 => Gosu::Image.new("media/chip/kusa.png"),
            2 => Gosu::Image.new("media/chip/tuti.png"),
            3 => Gosu::Image.new("media/chip/object3.png"),
            4 => Gosu::Image.new("media/chip/object4.png"),
            5 => Gosu::Image.new("media/chip/object5.png")
        }
    end

    def draw(x, y)
        @image.draw(x, y, 0)

    end

end
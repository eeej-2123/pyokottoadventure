class Start
    def initialize(window)
        @name=Gosu::Image.new("media/start/name.png")
        @back=Gosu::Image.new("media/back/Sora.png")
        @start_b=Gosu::Image.new("media/start/start_b.png")
        @sousa_b=Gosu::Image.new("media/start/sousa_b.png")
        @settei_b=Gosu::Image.new("media/start/settei_b.png")
    end



    def draw
        @name.draw(0, 0, 0)
        @back.draw(0, 0, -1)
        @start_b.draw(320 - 89.5, 320, 0)
        @settei_b.draw(170, 400, 0)
        @sousa_b.draw(320, 400, 0)
    end
end
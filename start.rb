class Start
    def initialize(window)
        @name=Gosu::Image.new("media/start/name2.png")
        @back=Gosu::Image.new("media/back/Sora.png")
        @start_b=Gosu::Image.new("media/start/start_b.png")
        @sousa_b=Gosu::Image.new("media/start/sousa_b.png")
        @settei_b=Gosu::Image.new("media/start/settei_b.png")
        @select=Gosu::Image.new("media/start/select.png")

        @select_mode = 0
    end

    def change_mode(i)
        if i == 0 #左
            if @select_mode == 2
                @select_mode = 1
            end
        end

        if i == 1 #右
            if @select_mode == 1
                @select_mode = 2
            end
        end

        if i == 2 #上
            if @select_mode==1 || @select_mode==2
                @select_mode = 0
            end
        end

        if i == 3 #下
            if @select_mode == 0
                @select_mode = 1
            end
        end
    end

    def selected
        if @select_mode == 0
            return 1
        end
    end
    
    def draw
        @name.draw(84.5, 0, 0)
        @back.draw(0, 0, -1)
        @start_b.draw(320 - 179, 200, 0)
        @settei_b.draw(95, 350, 0)
        @sousa_b.draw(345, 350, 0)
        if @select_mode == 0
            @select.draw(85, 270, 0)
        elsif @select_mode == 1
            @select.draw(30, 360, 0)
        elsif @select_mode == 2
            @select.draw(280, 360, 0)
        end
    end
end
class Start
    def initialize(window)
        @name=Gosu::Image.new("media/start/name2.png")
        @back=Gosu::Image.new("media/back/Sora.png")
        @start_b=Gosu::Image.new("media/start/start_b.png")
        @sousa_b=Gosu::Image.new("media/start/sousa_b.png")
        @settei_b=Gosu::Image.new("media/start/settei_b.png")
        @select=Gosu::Image.new("media/start/select.png")
        @settei=Gosu::Image.new("media/back/settei.png")
        @sousa=Gosu::Image.new("media/back/sousa.png")
        @settei_s=Gosu::Image.new("media/clear/ninjin.png")
        @modori=Gosu::Image.new("media/back/modori.png")

        @sentaku=Gosu::Image.new("media/back/sentaku.png")
        @kettei=Gosu::Image.new("media/back/kettei.png")

        @se_select= Gosu::Sample.new("bgm/select.mp3")
        @se_decide= Gosu::Sample.new("bgm/decide.mp3")

        @settei_mode = 0
        @select_mode = 0
        @sound_size = 1.0
        @sound=Array.new(2)
        @sound[0] = 1
        @sound[1] = 1
        @font = Gosu::Font.new(26)
    end

    def change_sound(sound)
        @sound_size = (sound == -1) ? 0.0 : 1.0
    end

    def get_sound(i)
        return @sound[i]
    end

    def get_settei
        return @settei_mode
    end

    def change_mode(i,scleen)
        if scleen == 0
            if i == 0 #左
                if @select_mode == 2
                    @se_select.play(@sound_size)
                    @select_mode = 1
                end
            end

            if i == 1 #右
                if @select_mode == 1
                    @se_select.play(@sound_size)
                    @select_mode = 2
                end
            end

            if i == 2 #上
                if @select_mode==1 || @select_mode==2
                    @se_select.play(@sound_size)
                    @select_mode = 0
                end
            end

            if i == 3 #下
                if @select_mode == 0
                    @se_select.play(@sound_size)
                    @select_mode = 1
                end
            end
        elsif scleen == 2
            if i == 0 || i == 1#左右
                if @settei_mode == 0 || @settei_mode == 1
                    @se_select.play(@sound_size)
                    @sound[@settei_mode] *= -1
                end
            end

            if i == 2 #上
                if @settei_mode==2 || @settei_mode==1
                    @se_select.play(@sound_size)
                    @settei_mode -= 1
                end
            end

            if i == 3 #下
                if @settei_mode == 0 || @settei_mode == 1
                    @se_select.play(@sound_size)
                    @settei_mode += 1
                end
            end
        end
    end

    def selected
        @se_decide.play(@sound_size)
        if @select_mode == 0
            return 1
        elsif @select_mode == 1
            return 2
        elsif @select_mode == 2
            return 3
        end
    end
    
        def draw_settei
        @name.draw(84.5, 0, 0)
        @back.draw(0, 0, -1)
        @settei.draw(0, 0, 0)

        if @settei_mode == 0
            @settei_s.draw(110, 175, 0)
        elsif @settei_mode == 1
            @settei_s.draw(110, 250, 0)
        elsif @settei_mode == 2
            @settei_s.draw(160, 335, 0)
        end

        # ON/OFF表示
        bgm_text = @sound[0] == 1 ? "ON" : "OFF"
        se_text  = @sound[1] == 1 ? "ON" : "OFF"
        @font.draw_text(bgm_text, 405, 190, 1)
        @font.draw_text(se_text,  405, 265, 1)
    end

    def draw_sousa
        @name.draw(84.5, 0, 0)
        @back.draw(0, 0, -1)
        @sousa.draw(0, 0, 0)
        @modori.draw(320-75,430,1)
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
        @sentaku.draw(320-150,440,0)
        @kettei.draw(320,440,0)
    end
end
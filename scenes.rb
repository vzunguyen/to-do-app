require 'rubygems'
require 'gosu'
require_relative 'todo'
require_relative 'player'


WIDTH = 900
HEIGHT = 600
BORDER = 30

module ZOrder 
    BACKGROUND, BUTTONS, TEXT_FIELD, AVATAR = *0..3
end

class ToDoWindow < Gosu::Window

    def initialize
        super WIDTH, HEIGHT 
        self.caption = "To Do Game"
        @background_image = Gosu::Image.new(self,"start_images/background.jpg")
        @play_button = Gosu::Image.new(self,"start_images/play_button.png")
        @play_button_hover = Gosu::Image.new(self, "start_images/play_button_hover.png")
        @hover_PLAY = false
        @info_font = Gosu::Font.new(20)
        @scene = :start
        @coin_earned = 0
    end

    def draw_background
        @background_image.draw(0,0,ZOrder::BACKGROUND)
    end

    def draw_buttons
        @play_button.draw(WIDTH/2.5,HEIGHT/2,ZOrder::BUTTONS)
    end

    def mouse_over_play_button(mouse_x, mouse_y)
        if ((mouse_x > WIDTH/2.5 and mouse_x < 547) and (mouse_y > 310 and mouse_y < 365))
           true
        else
          false
        end
    end

    def area_clicked(leftX, rightX, topY, bottomY)
        return mouse_x >= leftX && mouse_x <= rightX && mouse_y >= topY && mouse_y <= bottomY
     end


    def update_start
        if mouse_over_play_button(mouse_x, mouse_y)
            @hover_PLAY = true
          else
            @hover_PLAY = false
          end
    end

    
    def draw_start
        draw_background()
        draw_buttons()
        
        if @hover_PLAY
            @play_button_hover.draw(WIDTH/2.5,HEIGHT/2,ZOrder::BUTTONS)
        end
        # Draw the mouse_x
        @info_font.draw("mouse_x: #{mouse_x}", 0, 550, ZOrder::BUTTONS, 1.0, 1.0, Gosu::Color::BLACK)
        # Draw the mouse_y position
        @info_font.draw("mouse_y: #{mouse_y}", 150, 550, ZOrder::BUTTONS, 1.0, 1.0, Gosu::Color::BLACK)
    end

    def button_down_start(id)
        case id
        when Gosu::MsLeft
            if mouse_over_play_button(mouse_x, mouse_y)
                initialize_game
            end
        end
    end

    def initialize_game

        @song = Gosu::Song.new("music/music.mp3")
        @song.volume = 0.3
        @song.play(looping = true)
        @sound_on = Gosu::Image.new("asset/sound_on.png")
        @sound_off = Gosu::Image.new("asset/sound_off.png")
        
        @todo = ToDoField.new(self)
        @todo_list = @todo.read_todo_list()
        @todo_font = Gosu::Font.new(14)
        @coin_font = Gosu::Font.new(16)
        
        @player = Player.new(self)
        @scene = :game
    end

    def update_game
        @todo.update
    end

    def add_coin
        @coin_earned += 1
    end

    def draw_coin_earned
        @coin_font.draw(@coin_earned.to_s,231 , 55, ZOrder::BUTTONS, 1, 1, Gosu::Color::WHITE)
    end

    def draw_sound_button
        @sound_on.draw(WIDTH - 100, BORDER, ZOrder::BUTTONS)
        @sound_off.draw(WIDTH - 60, BORDER, ZOrder::BUTTONS)
    end

    def draw_game
        draw_background()
        draw_sound_button()
        draw_coin_earned()
        @todo.draw
        @player.draw
        # Draw the mouse_x
        @info_font.draw("mouse_x: #{mouse_x}", 0, 550, ZOrder::BUTTONS, 1.0, 1.0, Gosu::Color::BLACK)
        # Draw the mouse_y position
        @info_font.draw("mouse_y: #{mouse_y}", 150, 550, ZOrder::BUTTONS, 1.0, 1.0, Gosu::Color::BLACK)
    end

    def gain_focus()
    end

    def button_down_game(id)
        case id
        when Gosu::MsLeft
            if area_clicked(WIDTH - 100, WIDTH - 100 + @sound_on.width, BORDER, BORDER + @sound_on.height)
                @song.play(looping = true)
            end
            if area_clicked(WIDTH - 60, WIDTH - 60 + @sound_off.width, BORDER, BORDER + @sound_off.height)
                @song.pause
            end
        end
    end

    def needs_cursor?; true; end

    def update
        case @scene
        when :start
            update_start
        when :game
            @todo.update
            update_game
        end
    end

    def draw
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        end
    end

    def button_down(id)
        case @scene
        when :start
            button_down_start(id)
        when :game
            button_down_game(id)
        end
        #Escaping game
        close if id == Gosu::KbEscape 
    end

end

ToDoWindow.new.show if __FILE__ == $0

 # ref https://learning.oreilly.com/library/view/learn-game-programming/9781680501537/f_0021.html 

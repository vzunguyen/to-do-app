require 'rubygems'
require 'gosu'
require_relative 'scenes'
require_relative 'player'


class ToDo
    attr_accessor :description, :time, :completed, :available

    def initialize(description, time)
        @description = description
        @time = time
        @completed = false
        @available = false
    end
end

class ToDoField 
    def initialize(window)
        @todo_file = "todo_list.txt"
        @todo_list = read_todo_list()

        @check_box = Gosu::Image.new("box/checkbox.png")
        @text_box = Gosu::Image.new("box/text_field.png")
        @tick = Gosu::Image.new("box/tick.png")
        @clicked_tick = nil
        @finished_task = nil

        @todo_font = Gosu::Font.new(20)
        
        @window = window
    end

    def read_todo_list()
        @todo_file = 'todo_list.txt'
        todo_file = File.new(@todo_file, "r")
    
        @todo_list = Array.new()
        count = todo_file.gets.to_i
        i = 0
        while i < count
          todo = read_todo(todo_file)
          @todo_list << todo
          i += 1
        end
        
        todo_file.close
        return @todo_list
    end
    
    def read_todo(a_file)
        todo_description = a_file.gets().chomp
        todo_time = a_file.gets.to_i
        @todo = ToDo.new(todo_description, todo_time)
        return @todo
    end

    def mouse_over_tick(leftX, rightX, topY, bottomY)
        if ((@window.mouse_x > leftX and @window.mouse_x < rightX) and (@window.mouse_y > topY and @window.mouse_y < bottomY))
           true
        else
          false
        end
    end

    def area_clicked(leftX, rightX, topY, bottomY)
        return @window.mouse_x >= leftX && @window.mouse_x <= rightX && @window.mouse_y >= topY && @window.mouse_y <= bottomY
     end

    def draw_checkbox(x, y)
        @check_box.draw(x, y, ZOrder::BUTTONS)
    end

    def draw_textbox(x, y)
        @text_box.draw(x, y, ZOrder::BUTTONS)
    end

    def draw_tick(x, y)
        @tick.draw(x , y, ZOrder::BUTTONS)
    end

    def draw_tick_completed(x, y, completed)
        if completed
            @tick.draw(x , y, ZOrder::BUTTONS)
        end
    end

    def update
        if @window.button_down?(Gosu::MsLeft)
            x = BORDER
            y = 200
            @todo_list.each do |todo|
              if @window.mouse_x.between?(x, x + @check_box.width) && @window.mouse_y.between?(y, y + @check_box.height)
                if todo.completed == false
                    @window.add_coin
                end
                todo.completed = true

                break
              end
              y += 80
            end
        end
    end

    def draw
        i = 0
        while i < 4
            draw_checkbox(BORDER, 200+(i*80)) #CHECKBOX WIDTH = 60
            #draw_tick(40, 210+(i*80)) #TICK WIDTH = 40
            draw_textbox(BORDER + @check_box.width + 5, 202 + (i*80))
            i += 1
        end

        if mouse_over_tick(40, 80, 210, 250)
            draw_tick(40, 210)
        end
        if mouse_over_tick(40, 80, 210 + 80, 250 + 80)
            draw_tick(40, 210 + 80)
        end
        if mouse_over_tick(40, 80, 210 + 80*2, 250 + 80*2)
            draw_tick(40, 210 + 80*2)
        end
        if mouse_over_tick(40, 80, 210 + 80*3, 250 + 80*3)
            draw_tick(40, 210 + 80*3)
        end
    
        i = 0
        while i < @todo_list.length
            x = BORDER
            y = 200 + (i * 80)
            draw_tick_completed(x + 10, 210 + (i*80) , @todo_list[i].completed)
            @todo_font.draw_text(@todo_list[i].description, x + @check_box.width + 60, y + 21, ZOrder::TEXT_FIELD, 1.0, 1.0, Gosu::Color::WHITE)
            i += 1
          end  
    end

    def button_down(id)
    end


end

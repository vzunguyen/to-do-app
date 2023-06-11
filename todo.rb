require 'rubygems'
require 'gosu'
require_relative 'scenes'
require_relative 'player'


class ToDo
    attr_accessor :description, :completed

    def initialize(description)
        @description = description
        @completed = false
    end
end

class TextField < Gosu::TextInput
    FONT = Gosu::Font.new(20)
    TEXT_COLOR = 0xff_ffffff
    TEXT_FIELD_WIDTH = 498
    TEXT_FIELD_HEIGHT = FONT.height
    PADDING = 10
    LENGTH_LIMIT = 50
    CARET_COLOR = 0xff_ffffff
    TEXT_FIELD_COLOR = 0xcc_666666
    SELECTION_COLOR = 0xcc_0000ff

    attr_reader :x, :y
    def initialize(window, x, y)
        super()
        @window, @x, @y = window, x, y
        self.text = "Click to edit"
    end



    def filter new_text
        #limit the length of the text
        allowed_length = [LENGTH_LIMIT - text.length, 0].max
        new_text[0, allowed_length]
    end

    def draw
            color = TEXT_FIELD_COLOR
        Gosu.draw_rect(x - PADDING, y - PADDING, TEXT_FIELD_WIDTH + 2 * PADDING, TEXT_FIELD_HEIGHT + 2 * PADDING, color, ZOrder::MIDDLE)

        #Calculation of caret position
        position_x = x + FONT.text_width(self.text[0...self.caret_pos])

        if @window.text_input == self
            Gosu.draw_line position_x, y, CARET_COLOR, position_x, y + TEXT_FIELD_HEIGHT, CARET_COLOR, ZOrder::TOP
          end
      
          # Finally, draw the text itself!
          #FONT.draw_text(self.text, x, y, ZOrder::TOP)
    end

    def under_mouse?
    @window.mouse_x > x - PADDING and @window.mouse_x < x + TEXT_FIELD_WIDTH + PADDING and
    @window.mouse_y > y - PADDING and @window.mouse_y < y + TEXT_FIELD_HEIGHT + PADDING
    end

    def move_caret_to_mouse
        # Test character by character
        1.upto(self.text.length) do |i|
          if @window.mouse_x < x + FONT.text_width(text[0...i])
            self.caret_pos = self.selection_start = i - 1;
            return
          end
        end
        # Default case: user must have clicked the right edge
        self.caret_pos = self.selection_start = self.text.length
    end

end

class ToDoField
    FONT = Gosu::Font.new(20)

    def initialize(window)
        @window = window
        @was_text_field_focused = false

        @check_box = Gosu::Image.new("box/checkbox.png")
        @tick_image = Gosu::Image.new("asset/tick.png")
        @cross_image = Gosu::Image.new("asset/cross.png")
        @coin_sound = Gosu::Sample.new('music/coin_collect.mp3')
        
        @text_fields = Array.new(4) { |index| TextField.new(@window, 150, 220 + (index * 80)) }
        @todo_list = read_todo_list('todo_list.txt')

    end

    def write_todo_file(file_new)
            todo_file = File.new(file_new, "w")
            todo_file.puts('4')
            i = 0
            while i < 4
                todo_file.puts(@text_fields[i].text) 
                puts @text_fields[i].text
                #@text_fields.each do |text_field|
                #    todo_file.puts(text_field.text)
                #end
                i += 1
            end
            todo_file.close
    end

    def read_todo_list(file_new)
        #a_todo_file = 'todo_list.txt'
        todo_file = File.new(file_new, "r")
    
        @todo_list = Array.new()
        count = todo_file.gets.to_i
        i = 0
        while i < count
          todo = read_todo(todo_file)
          @text_fields[i].text = todo.description
          @todo_list << todo
          i += 1
        end
        
        todo_file.close
        return @todo_list
    end
    
    def read_todo(file_new)
        todo_description = file_new.gets()
        @todo = ToDo.new(todo_description)
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

    def draw_cross(x,y)
        @cross_image.draw(x, y, ZOrder::TOP)
    end

    def draw_checkbox(x, y)
        @check_box.draw(x, y, ZOrder::MIDDLE)
    end

    def draw_tick(x, y)
        @tick_image.draw(x , y, ZOrder::TOP)
    end

    def draw_tick_completed(x, y, completed)
        if completed
            @tick_image.draw(x , y, ZOrder::TOP)
        end
    end

    def draw_texts
        i = 0
        while i < 4
            FONT.draw_text(@text_fields[i].text, 150, 220 + (i * 80), ZOrder::TOP)
            i += 1
        end
    end

    def update_completed_task
        if @window.button_down?(Gosu::MsLeft)
            x = BORDER
            y = 200
            @todo_list.each do |todo|
              if @window.mouse_x.between?(x, x + @check_box.width) && @window.mouse_y.between?(y, y + @check_box.height)
                if todo.completed == false
                    @window.add_coin
                    @coin_sound.play
                end
                todo.completed = true

                break
              end
              y += 80
            end
        end
    end

    def update_deleted_tick
        if @window.button_down?(Gosu::MsLeft)
            #deleting tick
            x = 695
            y = 210
            @todo_list.each do |todo|
                if @window.mouse_x.between?(x, x + @cross_image.width) && @window.mouse_y.between?(y, y + @cross_image.height)
                    if todo.completed == true
                    todo.completed = false
                    end
                break
                end
              y += 80
            end
        end
    end

    def update_deleted_text
        #reassigning x and y and deleting text
        if @window.button_down?(Gosu::MsLeft)
            x = 695
            y = 210
            @text_fields.each do |text_field|
                if @window.mouse_x.between?(x, x + @cross_image.width) && @window.mouse_y.between?(y, y + @cross_image.height)
                    text_field.text = 'Click to edit'
                #break
                end
              y += 80
            end
        end
    end

    def update
        update_completed_task
        update_deleted_tick
        update_deleted_text
        if @window.text_input != nil
            @was_text_field_focused = true 
        end
        if @window.text_input == nil and @was_text_field_focused == true
            write_todo_file('todo_list.txt')
            @was_text_field_focused = false
        end

        # IF TEXTBOX SELECTED
            # TEXTBOX WAS SELECTED = TRUE
        # IF TEXTBOX NOT SELECTED AND TEXTBOX WAS SELECTED == TRUE
            # WRITE TODO FILE
            # TEXTBOX WAS SELECTED = FALSE
    end

    def draw

        @text_fields.each { |tf| tf.draw() }
        draw_texts()

        i = 0
        while i < 4
            draw_checkbox(BORDER, 200+(i*80)) #CHECKBOX WIDTH = 60
            draw_cross(695, 210+(i*80))
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
#            FONT.draw_text(@todo_list[i].description, x + @check_box.width + 60, y + 21, ZOrder::TEXT_FIELD, 1.0, 1.0, Gosu::Color::WHITE)
            i += 1
          end  
    end

    def button_down_textfields(id)
        if id == Gosu::MS_LEFT
            # Mouse click: Select text field based on mouse position.
            @window.text_input = @text_fields.find { |tf| tf.under_mouse? }
            # Also move caret to clicked position
            @window.text_input.move_caret_to_mouse unless @window.text_input.nil?
        end
    end

    def button_down(id)
        button_down_textfields(id)
    end
end

# https://github.com/gosu/gosu-examples/blob/master/examples/text_input.rb

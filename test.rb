



class TextField < Gosu::TextInput
    attr_reader :x, :y
    def initialize(window, x, y)
        super()
        @window, @x, @y = window, x, y
        self.text = "Click to edit"
    end

    def update
    end

    def draw
    end

    def button_down(id)
    end
end

class ToDoField
    FONT = Gosu::Font.new(20)

    def initialize(window)
        @window = window

        @check_box = Gosu::Image.new("box/checkbox.png")
        @tick_image = Gosu::Image.new("asset/tick.png")
        @cross_image = Gosu::Image.new("asset/cross.png")

        @text_fields
        @completed 
    end
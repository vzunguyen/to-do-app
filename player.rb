require 'gosu'
require 'rubygems'
require_relative 'todo'
require_relative 'scenes'

class Player
    def initialize(window)
        @avatar_box = Gosu::Image.new('box/avatar_box.png')
        @cat = Gosu::Image.new('characters/cat.png')
        @coin_image = Gosu::Image.new('asset/coin.png')
        @window = window
    end

    def draw
        @avatar_box.draw(BORDER, BORDER, ZOrder::MIDDLE)
        @cat.draw(BORDER + 50, BORDER + 50, ZOrder::TOP)
        @coin_image.draw(BORDER + @avatar_box.width + 5, BORDER + 10, ZOrder::TOP)
    end
end
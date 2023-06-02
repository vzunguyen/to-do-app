require 'gosu'
require 'rubygems'
require_relative 'todo'
require_relative 'scenes'


class Player
    def initialize(window)
        @avatar_box = Gosu::Image.new('box/avatar_box.png')
        @character = nil 
        @default_character = Gosu::Image.new('characters/character_1.png')
        @character_2 = 0
        @coin_image = Gosu::Image.new('asset/coin.png')
        @window = window
    end

    def draw
        @avatar_box.draw(BORDER, BORDER, ZOrder::BUTTONS)
        @default_character.draw(BORDER + 16, BORDER + 27, ZOrder::BUTTONS)
        @coin_image.draw(BORDER + @avatar_box.width + 5, BORDER + 10, ZOrder::BUTTONS)
    end
end
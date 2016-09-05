require_relative "./Card"

class Deck

  def initialize
    @deck = []

    Card.number.each do |number|
      Card.color.each do |color|
        Card.texture.each do |texture|
          Card.shape.each do |shape|
            @deck << Card.new(number, color, shape, texture)
          end
        end
      end
    end
    @deck.shuffle!
    @deck.shuffle!
  end


  def is_empty?
    !@deck.any?
  end

  def next_card
    @deck.pop
  end
end

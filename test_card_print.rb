require 'colorize'
require_relative "./Card"

class TestCardPrint

  my_card = Card.new(1, 'red', 'squiggle', 'empty')
  Card.print_card(my_card)
  puts my_card.shape
  puts my_card.texture


end
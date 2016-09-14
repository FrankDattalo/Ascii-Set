require 'colorize'
require_relative "./Card"

class TestCardPrint

  my_card = Card.new(3, :green, :squiggle, :empty)
  Card.print_card(my_card)


end
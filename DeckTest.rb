require_relative "./Deck"

d = Deck.new

while !d.is_empty?
  puts d.next_card
end

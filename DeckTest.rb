require_relative "./Deck"

d = Deck.new

while !d.is_empty?
	card = d.next_card
	#card.print
	puts card
	i = 1
	while i <= 17
		puts card.get_row_string i
		i += 1
	end
end

require 'colorize'
class Card

  def self.number
    [1, 2, 3]
  end

  def self.color
    [:red, :green, :purple]
  end

  def self.shape
    [:squiggle, :oval, :diamond]
  end

  def self.texture
    [:solid, :striped, :empty]
  end

  def initialize(number, color, shape, texture)
    @shape = shape
    @color = color
    @texture = texture
    @number = number
  end

  def color
    @color
  end

  def number
    @number
  end

  def texture
    @texture
  end

  def shape
    @shape
  end

  def to_s
    "(#{@color}, #{@number}, #{@shape}, #{@texture})"
  end

  def self.print_card(card)
    card_print = " _____________________________ \n"
    card_print += "|                             |\n"
    card_print += "|                             |\n"
    puts card_print
    case Card.number
      when 1

        case Card.shape
          when :squiggle
            if card.texture = solid
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif card.texture = striped
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif card.texture = :empty
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              print_squiggle(card_print)
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|_____________________________|\n"
              puts card_print.red

            else
              puts "helpme"


            end


          when :oval
            if Card.texture = solid
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif Card.texture = striped
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif Card.texture = empty
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"


            end

          when :diamond
            if Card.texture = solid
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif Card.texture = striped
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"

            elsif Card.texture = empty
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"
              card_print += "|                             |\n"


            end

          else



        end



      when 2
        case Card.shape
          when squiggle
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end


          when oval
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end

          when diamond
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end

          else



        end


      when 3
        case Card.shape
          when squiggle
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end


          when oval
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end

          when diamond
            if Card.texture = solid

            elsif Card.texture = striped

            elsif Card.texture = empty


            end

          else



        end


      else

    end

   end

    def print_squiggle(card_print)
      card_print += "|           .~~._.~.          |\n"
      card_print += "|           \      /          |\n"
      card_print += "|            ^..^^^           |\n"
    end

    def print_oval(card_print)
      card_print += "|            ______           |\n"
      card_print += "|           /      \          |\n"
      card_print += "|           \______/          |\n"
    end

    def print_diamond(card_print)
      card_print += "|             / \             |\n"
      card_print += "|             \_/             |\n"
      card_print += "|                             |\n"
    end




  def self.is_set?(card1, card2, card3)
    Card.contains_same_or_all_different(:color, card1, card2, card3) &&
        Card.contains_same_or_all_different(:number, card1, card2, card3) &&
        Card.contains_same_or_all_different(:shape, card1, card2, card3) &&
        Card.contains_same_or_all_different(:texture, card1, card2, card3)
  end

  private

  def self.contains_same_or_all_different(property, card1, card2, card3)
    Card.contains_all_same(property, card1, card2, card3) ||
        Card.contains_all_different(property, card1, card2, card3)
  end

  def self.contains_all_same(property, card1, card2, card3)
    prop = card1.send(property) #get the value of the property
    return false if prop != card2.send(property) # if the second property is not the same return false
    return false if prop != card3.send(property) #if the last property is not the same return false
    true # true because they must be all same
  end

  def self.contains_all_different(property, card1, card2, card3)
    return false if card1.send(property) == card2.send(property)
    return false if card1.send(property) == card3.send(property)
    return false if card2.send(property) == card3.send(property)
    true
  end

end

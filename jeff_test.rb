require 'colorize'

class JeffTest



card_print = " _____________________________ \n"
card_print += "|                             |\n"
card_print += "|                             |\n"

  case Card.number
    when 1

      case Card.shape
        when squiggle
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


          end


        when oval
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

        when diamond
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

end
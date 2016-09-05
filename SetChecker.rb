require_relative "./Card"

class SetChecker

  def self.is_set?(card1, card2, card3)
    SetChecker.contains_same_or_all_different(:color, card1, card2, card3) &&
      SetChecker.contains_same_or_all_different(:number, card1, card2, card3) &&
        SetChecker.contains_same_or_all_different(:shape, card1, card2, card3) &&
          SetChecker.contains_same_or_all_different(:texture, card1, card2, card3)
  end

  def self.contains_same_or_all_different(property, card1, card2, card3)
    SetChecker.contains_all_same(property, card1, card2, card3) ||
      SetChecker.contains_all_different(property, card1, card2, card3)
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

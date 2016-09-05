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
end

class Player


  def initialize(name, set, stuck, score)
    @name = name
    @set = set
    @stuck = stuck
    @score = score
  end

  def name
    @name
  end

  def score
    @score
  end

  def score(new_score)
    @score=new_score
  end

  def stuck(yes_or_no)
    @stuck = yes_or_no
  end

  def set(set_string)
    @set = set_string
  end

  def send_set

  end

end
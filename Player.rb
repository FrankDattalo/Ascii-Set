class Player


  def initialize(name, score, stuck, hint, set, attempts, speed, ready)
    @name = name
    @score = score
    @stuck = stuck
    @hint = hint
    @set = set
    @attempts = attempts
    @speed = speed
    @ready = ready
  end

  def name
    @name
  end

  def score
    @score
  end

  def score=(new_score)
    @score=new_score
  end

  def stuck
    @stuck
  end

  def hint
    @hint
  end

  def set
    @set
  end

  def attempts
    @attempts
  end

  def speed
    @speed
  end

  def ready
    @ready
  end



end
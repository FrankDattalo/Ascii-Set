class Player

	attr_accessor :score
	attr_reader :name

  def initialize(name)
    @name = name
    @score = 0
  end

	def to_json(options = nil)
		'{"name":%s,"score":%s}' % [@name.to_json, @score.to_json]
	end
end

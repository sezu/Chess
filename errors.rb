
class InCheckError < StandardError
  def initialize(msg = "Moving that piece would leave your defenseless king under attack!@!!!")
    super
  end
end

class SelectionError < StandardError
  def initialize(msg = "There is no piece there. Do you even lift?\n")
    super
  end
end

class WrongTeamError < StandardError
  def initialize(msg = "You can't move the enemy team's pieces. Please select your own pieces\n")
    super
  end
end

class EndpointError < StandardError
  def initialize (msg = "That piece can't move there. Please select a valid endpoint\n")
    super
  end
end

class BadInputError < TypeError
  def initialize (msg = "Please use algebraic chess notation.  eg.  'e3 e4' \n")
    super
  end
end

class NilClass
  def dup
    nil
  end
end

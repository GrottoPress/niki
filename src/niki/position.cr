struct Niki::Position
  include Resource

  getter x : Int32
  getter y : Int32

  def initialize(@x, @y)
  end
end

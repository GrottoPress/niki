struct Niki::Message::ComputerAction
  enum Button
    Left
    Right
    Wheel
    Back
    Forward
  end

  enum Type
    Click
    DoubleClick
    Drag
    Keypress
    Move
    Screenshot
    Scroll
    Type
    Wait
  end

  include Resource

  getter button : Button?
  getter keys : Array(String)
  getter path : Array(Position)?
  getter scroll_x : Int32?
  getter scroll_y : Int32?
  getter text : String?
  getter type : Type
  getter url : String?
  getter x : Int32?
  getter y : Int32?

  def position : Position?
    @x.try do |x|
      @y.try { |y| Position.new(x, y) }
    end
  end

  def scroll_position : Position?
    @scroll_x.try do |x|
      @scroll_y.try { |y| Position.new(x, y) }
    end
  end
end

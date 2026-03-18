struct Niki::Completion::Image
  enum Detail
    Auto
    Low
    High
  end

  include Resource

  getter detail : Detail
  getter url : String
end

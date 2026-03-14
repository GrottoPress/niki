struct Niki::Message::Text
  enum Verbosity
    Low
    Medium
    High
  end

  include Resource

  getter format : Format?
  getter verbosity : Verbosity?
end

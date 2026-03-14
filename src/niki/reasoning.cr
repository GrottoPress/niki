struct Niki::Reasoning
  enum Effort
    None
    Minimal
    Low
    Medium
    High
    XHigh
  end

  enum Summary
    Auto
    Concise
    Detailed
  end

  include Resource

  getter effort : Effort?
  getter summary : Summary?
end

struct Niki::Message::SafetyCheck
  include Resource

  getter id : String
  getter code : String?
  getter message : String?
end

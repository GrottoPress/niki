struct Niki::Skill::Source
  enum Type
    Base64
  end

  include Resource

  getter data : String
  getter media_type : String
  getter type : Type
end

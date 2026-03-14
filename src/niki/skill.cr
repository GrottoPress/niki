struct Niki::Skill
  enum Type
    SkillReference
    Inline
  end

  include Resource

  getter description : String?
  getter name : String?
  getter skill_id : String?
  getter source : Source?
  getter type : Type?
  getter version : String?
end

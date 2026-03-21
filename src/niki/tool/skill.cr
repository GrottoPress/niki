struct Niki::Tool::Skill
  enum Type
    SkillReference
    Inline
  end

  include Resource

  getter description : String?
  getter name : String?
  getter path : String?
  getter skill_id : String?
  getter source : Niki::Skill::Source?
  getter type : Type?
  getter version : String?
end

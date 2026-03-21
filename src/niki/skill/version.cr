struct Niki::Skill::Version
  include Resource

  getter? deleted : Bool?
  getter description : String?
  getter id : String?
  getter name : String?
  getter skill_id : String?
  getter version : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?
end

struct Niki::Skill
  include Resource

  getter default_version : String?
  getter? deleted : Bool?
  getter description : String?
  getter id : String?
  getter latest_version : String?
  getter name : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?
end

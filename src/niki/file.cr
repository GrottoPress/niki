struct Niki::File
  include Resource

  getter bytes : Int64?
  getter container_id : String?
  getter? deleted : Bool?
  getter filename : String?
  getter id : String?
  getter path : String?
  getter purpose : String?
  getter source : String? # Role?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter expires_at : Time?
end

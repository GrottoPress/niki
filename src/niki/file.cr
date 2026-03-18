struct Niki::File
  include Resource

  getter id : String?
  getter bytes : Int64?
  getter filename : String?
  getter purpose : String?
  getter? deleted : Bool?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter expires_at : Time?
end

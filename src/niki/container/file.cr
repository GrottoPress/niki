struct Niki::Container::File
  include Resource

  getter bytes : Int64?
  getter container_id : String?
  getter? deleted : Bool?
  getter id : String?
  getter path : String?
  getter source : String? # Role?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?
end

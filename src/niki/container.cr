struct Niki::Container
  enum Type
    Auto
  end

  include Resource

  getter? deleted : Bool?
  getter id : String?
  getter name : String?
  getter status : String?
  getter expires_after : ExpiresAfter?
  getter file_ids : Array(String)?
  getter memory_limit : String?
  getter network_policy : NetworkPolicy?
  getter type : Type = :auto

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter last_active_at : Time?
end

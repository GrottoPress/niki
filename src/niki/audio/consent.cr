struct Niki::Audio::Consent
  include Resource

  getter? deleted : Bool?
  getter id : String?
  getter language : String?
  getter name : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?
end

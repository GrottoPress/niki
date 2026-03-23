struct Niki::Audio::Voice
  include Resource

  getter id : String?
  getter name : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?
end

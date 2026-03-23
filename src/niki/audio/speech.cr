struct Niki::Audio::Speech
  include Resource

  getter id : String?
  getter model : String?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created : Time?
end

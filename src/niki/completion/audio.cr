struct Niki::Completion::Audio
  include Resource

  getter data : String
  getter id : String
  getter transcript : String

  @[JSON::Field(converter: Time::EpochConverter)]
  getter expires_at : Time
end

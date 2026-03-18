struct Niki::Completion
  include Resource

  getter choices : Array(Choice)?
  getter? deleted : Bool?
  getter id : String?
  getter model : String?
  getter service_tier : ServiceTier?
  getter usage : Usage?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created : Time?
end

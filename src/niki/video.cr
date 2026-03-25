struct Niki::Video
  include Resource

  SIZE_720_1280 = "720x1280"
  SIZE_1280_720 = "1280x720"
  SIZE_1024_1792 = "1024x1792"
  SIZE_1792_1024 = "1792x1024"

  getter? deleted : Bool?
  getter id : String?
  getter model : String?
  getter progress : Int32?
  getter prompt : String?
  getter remixed_from_video_id : String?
  getter seconds : String?
  getter size : String?
  getter status : Message::Status?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter completed_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter expires_at : Time?
end

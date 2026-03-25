require "./models/**"

struct Niki::Model
  include Resource

  include Models::Audio
  include Models::Chat
  include Models::Code
  include Models::Embedding
  include Models::Image
  include Models::Video

  getter? deleted : Bool?
  getter created : Int64?
  getter id : String?
  getter owned_by : String?
end

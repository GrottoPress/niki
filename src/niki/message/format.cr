struct Niki::Message::Format
  enum Type
    Text
    JsonSchema
    JsonObject
  end

  include Resource

  getter description : String?
  getter name : String?
  getter schema : Hash(String, JSON::Any)?
  getter? strict : Bool?
  getter type : Type
end

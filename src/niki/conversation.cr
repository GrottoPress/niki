struct Niki::Conversation
  include Resource

  getter id : String?
  getter created_at : Int64?
  getter metadata : Hash(String, String)?
  getter? deleted : Bool?
end

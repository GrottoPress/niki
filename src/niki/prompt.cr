struct Niki::Prompt
  include Resource

  getter id : String
  getter variables : Hash(String, String | Message::Content)?
  getter version : String?
end

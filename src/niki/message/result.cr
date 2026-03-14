struct Niki::Message::Result
  include Resource

  getter attributes : Hash(String, String | Bool | Float64)?
  getter file_id : String?
  getter filename : String?
  getter score : Float64?
  getter text : String?
end

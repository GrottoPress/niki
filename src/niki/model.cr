struct Niki::Model
  include Resource

  getter? deleted : Bool?
  getter created : Int64?
  getter id : String?
  getter owned_by : String?
end

struct Niki::Model
  include Resource

  SORA_2 = "sora-2"
  SORA_2_PRO = "sora-2-pro"
  SORA_2_2025_10_06 = "sora-2-2025-10-06"
  SORA_2_PRO_2025_10_06 = "sora-2-pro-2025-10-06"
  SORA_2_2025_12_08 = "sora-2-2025-12-08"

  getter? deleted : Bool?
  getter created : Int64?
  getter id : String?
  getter owned_by : String?
end

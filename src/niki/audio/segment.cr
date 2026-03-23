struct Niki::Audio::Segment
  include Resource

  getter avg_logprob : Float64?
  getter compression_ratio : Float64?
  getter end : Float64?
  getter id : String?
  getter no_speech_prob : Float64?
  getter seek : Int32?
  getter speaker : String?
  getter start : Float64?
  getter temperature : Float64?
  getter text : String?
  getter tokens : Array(Float32)?
  getter type : String?
end

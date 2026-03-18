class Niki::LogProb
  include Resource

  getter bytes : Array(Int32)?
  getter logprob : Int32?
  getter top_logprobs : Array(self)?
  getter token : String?
end

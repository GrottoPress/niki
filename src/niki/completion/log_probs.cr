struct Niki::Completion::LogProbs
  include Resource

  getter content : Array(LogProb)
  getter refusal : Array(LogProb)
end

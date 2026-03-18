struct Niki::Completion::LogProbs
  include Resource

  getter content : Array(Niki::Message::LogProb)
  getter refusal : Array(Niki::Message::LogProb)
end

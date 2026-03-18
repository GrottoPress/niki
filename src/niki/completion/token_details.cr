struct Niki::Completion::TokenDetails
  include Resource

  getter accepted_prediction_tokens : Int32?
  getter audio_tokens : Int32?
  getter cached_tokens : Int32?
  getter reasoning_tokens : Int32?
  getter rejected_prediction_tokens : Int32?
end

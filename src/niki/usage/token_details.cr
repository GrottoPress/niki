struct Niki::Usage::TokenDetails
  include Resource

  getter cached_tokens : Int32?
  getter reasoning_tokens : Int32?
end

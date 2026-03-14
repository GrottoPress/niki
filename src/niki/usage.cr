struct Niki::Usage
  include Resource

  getter input_tokens : Int32?
  getter input_tokens_details : TokenDetails?
  getter output_tokens : Int32?
  getter output_tokens_details : TokenDetails?
  getter total_tokens : Int32?
end

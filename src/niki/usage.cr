struct Niki::Usage
  enum Type
    Tokens
    Duration
  end

  include Resource

  @seconds : Int32?

  getter input_tokens : Int32?
  getter input_tokens_details : TokenDetails?
  getter output_tokens : Int32?
  getter output_tokens_details : TokenDetails?
  getter prompt_tokens : Int32?
  getter prompt_tokens_details : TokenDetails?
  getter total_tokens : Int32?
  getter type : Type?

  def seconds : Time::Span?
    @seconds.try(&.seconds)
  end
end

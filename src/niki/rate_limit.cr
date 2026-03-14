struct Niki::RateLimit
  include Resource

  getter limit_requests : Int32?
  getter limit_tokens : Int32?
  getter remaining_requests : Int32?
  getter remaining_tokens : Int32?
  getter reset_requests : String?
  getter reset_tokens : String?

  def initialize(headers : HTTP::Headers)
    @limit_requests = headers["X-Ratelimit-Limit-Requests"]?.try(&.to_i)
    @limit_tokens = headers["X-Ratelimit-Limit-Tokens"]?.try(&.to_i)
    @remaining_requests = headers["X-Ratelimit-Remaining-Requests"]?.try(&.to_i)
    @remaining_tokens = headers["X-Ratelimit-Remaining-Tokens"]?.try(&.to_i)
    @reset_requests = headers["X-Ratelimit-Reset-Requests"]?
    @reset_tokens = headers["X-Ratelimit-Reset-Tokens"]?
  end

  def self.new(response : HTTP::Client::Response)
    new(response.headers)
  end
end

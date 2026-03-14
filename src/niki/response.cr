module Niki::Response
  macro included
    include Niki::Resource

    getter error : Niki::Error?
    getter object : String?

    @[JSON::Field(ignore: true)]
    getter organization : String?

    @[JSON::Field(ignore: true)]
    getter processing_ms : Time::Span?

    @[JSON::Field(ignore: true)]
    getter rate_limit : Niki::RateLimit?

    @[JSON::Field(ignore: true)]
    getter request_id : String?

    @[JSON::Field(ignore: true)]
    getter version : String?

    def self.from_json(response : HTTP::Client::Response) : self
      from_json(response.body).set_additional_properties(response)
    end

    protected def set_additional_properties(response : HTTP::Client::Response)
      @organization = response.headers["OpenAI-Organization"]?
      @rate_limit = Niki::RateLimit.new(response)
      @request_id = response.headers["X-Request-ID"]?
      @version = response.headers["OpenAI-Version"]?

      @processing_ms = response.headers["Openai-Processing-ms"]?.try do |ms|
        ms.to_i64.milliseconds
      end

      self
    end
  end
end

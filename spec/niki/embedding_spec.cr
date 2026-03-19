require "../spec_helper"

describe Niki::Embedding::Endpoint do
  describe "#create" do
    it "creates embedding" do
      api_key = "x7y8z9"
      model_id = "text-embedding-3-small"
      reset_requests = "1s"

      # Got this from <https://github.com/openai/openai-openapi/issues/424>
      base64 = "nMcovm6gOb7ldwO/AESlvk0Avz2nZIq+3c+EvZvdFT9HsZa9oSy+vg=="

      vector = Array(Float32){
        -0.16482395,
        -0.18127605,
        -0.5135482,
        -0.32278442,
        0.09326229,
        -0.27029917,
        -0.06484959,
        0.5854127,
        -0.07358032,
        -0.37143424
      }

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "object": "embedding",
              "embedding": "#{base64}",
              "index": 0
            }
          ],
          "model": "#{model_id}",
          "usage": {
            "prompt_tokens": 8,
            "total_tokens": 8
          }
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/embeddings")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)

      response = client.embeddings.create(
        input: "The quick brown fox",
        model: model_id,
        encoding_format: "base64"
      )

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.try(&.first?).should be_a(Niki::Embedding)
      response.model.should eq(model_id)
      response.usage.should be_a(Niki::Usage)

      response.data.try &.first?.try do |embedding|
        embedding.vector.should eq(vector)
        embedding.index.should eq(0)
      end

      response.usage.try do |usage|
        usage.prompt_tokens.should eq(8)
        usage.total_tokens.should eq(8)
      end
    end
  end
end

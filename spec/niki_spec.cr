require "./spec_helper"

describe Niki do
  it "handles error" do
    api_key = "x7y8z9"
    organization_id = "d4e5f6"
    request_id = "a1b2c3"

    body = <<-'JSON'
      {
        "error": {
          "code": "server_error",
          "message": "Internal server error"
        }
      }
      JSON

    WebMock.stub(:POST, "https://api.openai.com/v1/responses")
      .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
      .to_return(body: body, headers: {
        "openai-organization" => organization_id,
        "x-request-id" => request_id
      })

    client = Niki.new(api_key)

    response = client.messages.create(
      model: "non-existent-model",
      max_tokens: 1024,
      messages: [{role: "user", content: "Hello, world"}]
    )

    response.request_id.should eq(request_id)
    response.organization.should eq(organization_id)

    response.data.should be_nil

    response.error.should be_a(Niki::Error)
    response.error.try(&.code.server_error?).should be_true
  end

  ENV["OPENAI_API_KEY"]?.presence.try do |api_key|
    it "connects to OpenAI" do
      WebMock.allow_net_connect = true

      client = Niki.new(api_key)
      response = client.messages.input_tokens

      response.data.should be_a(Niki::Usage)
    end
  end
end

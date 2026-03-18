require "../../spec_helper"

describe Niki::Completion::Message::Endpoint do
  describe "#list" do
    it "lists messages" do
      api_key = "x7y8z9"
      completion_id = "chatcmpl-abc123"
      request_id = "req_abc123"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "msg_123",
              "role": "assistant",
              "content": "Hello, world!",
              "content_parts": [],
              "annotations": [],
              "tool_calls": []
            }
          ],
          "first_id": "msg_123",
          "last_id": "msg_456",
          "has_more": false
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/chat/completions/#{completion_id}/messages"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {"x-request-id" => request_id})

      client = Niki.new(api_key)
      response = client.completions.messages.list(completion_id)

      response.request_id.should eq(request_id)
      response.data.should be_a(Array(Niki::Completion::Message))

      response.data.try &.first?.try do |message|
        message.id.should eq("msg_123")
        message.role.should_not be_nil
        message.content.should eq("Hello, world!")
      end
    end
  end
end

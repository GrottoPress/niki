require "../../spec_helper"

describe Niki::Message::InputItem::Endpoint do
  describe "#list" do
    it "lists input items" do
      api_key = "x7y8z9"
      response_id = "resp_67cb71b351908190a308f3859487620d06981a8637e6bc44"
      request_id = "req_abc123"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "msg_abc123",
              "type": "message",
              "role": "user",
              "content": [
                {
                  "type": "input_text",
                  "text": "Tell me a three sentence story about a unicorn."
                }
              ]
            }
          ],
          "first_id": "msg_abc123",
          "last_id": "msg_abc123",
          "has_more": false
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/responses/#{response_id}/input_items"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {"x-request-id" => request_id})

      client = Niki.new(api_key)
      response = client.messages.input_items.list(response_id)

      response.request_id.should eq(request_id)
      response.data.should be_a(Array(Niki::Message::Output))
    end
  end
end

require "../spec_helper"

describe Niki::Conversation::Endpoint do
  describe "#create" do
    it "creates conversation" do
      api_key = "x7y8z9"
      conversation_id = "conv_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{conversation_id}",
          "object": "conversation",
          "created_at": 1722475520
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/conversations"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.conversations.create

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Conversation)

      response.data.try do |conversation|
        conversation.id.should eq(conversation_id)
      end
    end
  end

  describe "#fetch" do
    it "retrieves conversation" do
      api_key = "x7y8z9"
      conversation_id = "conv_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{conversation_id}",
          "object": "conversation",
          "created_at": 1722475520,
          "metadata": {}
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/conversations/#{conversation_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.conversations.fetch(conversation_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Conversation)

      response.data.try do |conversation|
        conversation.id.should eq(conversation_id)
        conversation.created_at.should eq(1722475520)
      end
    end
  end

  describe "#update" do
    it "updates conversation" do
      api_key = "x7y8z9"
      conversation_id = "conv_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{conversation_id}",
          "object": "conversation",
          "created_at": 1722475520,
          "metadata": {}
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/conversations/#{conversation_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.conversations.update(conversation_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Conversation)

      response.data.try do |conversation|
        conversation.id.should eq(conversation_id)
      end
    end
  end

  describe "#delete" do
    it "deletes conversation" do
      api_key = "x7y8z9"
      conversation_id = "conv_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{conversation_id}",
          "object": "conversation.deleted",
          "deleted": true
        }
        JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/conversations/#{conversation_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.conversations.delete(conversation_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Conversation)

      response.data.try do |conversation|
        conversation.id.should eq(conversation_id)
        conversation.deleted?.should be_true
      end
    end
  end
end

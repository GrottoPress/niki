require "../spec_helper"

describe Niki::Completion::Endpoint do
  describe "#fetch" do
    it "retrieves completion" do
      api_key = "x7y8z9"
      completion_id = "chatcmpl-abc123"
      finish_reason = "stop"
      object = "chat.completion"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "#{object}",
          "id": "#{completion_id}",
          "model": "gpt-4o-2024-08-06",
          "created": 1738960610,
          "request_id": "req_ded8ab984ec4bf840f37566c1011c417",
          "tool_choice": null,
          "usage": {
            "total_tokens": 31,
            "completion_tokens": 18,
            "prompt_tokens": 13
          },
          "seed": 4944116822809979520,
          "top_p": 1.0,
          "temperature": 1.0,
          "presence_penalty": 0.0,
          "frequency_penalty": 0.0,
          "system_fingerprint": "fp_50cad350e4",
          "input_user": null,
          "service_tier": "default",
          "tools": null,
          "metadata": {},
          "choices": [
            {
              "index": 0,
              "message": {
                "content": "Mind of circuits hum...",
                "role": "assistant",
                "tool_calls": null,
                "function_call": null
              },
              "finish_reason": "#{finish_reason}",
              "logprobs": null
            }
          ],
          "response_format": null
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/chat/completions/#{completion_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.completions.fetch(completion_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Completion)
      response.object.should eq(object)

      response.data.try do |completion|
        completion.id.should eq(completion_id)
        completion.choices.try(&.first?).should be_a(Niki::Completion::Choice)
        completion.usage.should be_a(Niki::Usage)

        completion.choices.try &.first?.try do |choice|
          choice.message.should be_a(Niki::Completion::Message)

          choice.finish_reason
            .should(eq Niki::Completion::Choice::FinishReason::Stop)
        end
      end
    end
  end

  describe "#list" do
    it "lists completions" do
      api_key = "x7y8z9"
      object = "list"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "#{object}",
          "data": [
            {
              "id": "chatcmpl-123",
              "object": "chat.completion",
              "created": 1738960610,
              "model": "gpt-4o-2024-08-06",
              "choices": [],
              "usage": {
                "total_tokens": 10,
                "completion_tokens": 5,
                "prompt_tokens": 5
              }
            }
          ],
          "first_id": "chatcmpl-123",
          "last_id": "chatcmpl-456",
          "has_more": false
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/chat/completions?limit=20")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.completions.list(limit: "20")

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.object.should eq(object)
      response.data.should be_a(Array(Niki::Completion))
    end
  end

  describe "#create" do
    it "creates completion" do
      api_key = "x7y8z9"
      completion_id = "chatcmpl-xyz789"
      object = "chat.completion"
      reset_tokens = "6m0s"

      body = <<-JSON
        {
          "id": "#{completion_id}",
          "object": "#{object}",
          "created": 1738960610,
          "model": "gpt-4o-2024-08-06",
          "choices": [
            {
              "index": 0,
              "message": {
                "content": "Hello, world!",
                "role": "assistant"
              },
              "finish_reason": "stop"
            }
          ],
          "usage": {
            "total_tokens": 25,
            "completion_tokens": 10,
            "prompt_tokens": 15
          }
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/chat/completions")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-Ratelimit-reset-Tokens" => reset_tokens
        })

      client = Niki.new(api_key)
      response = client.completions.create(
        model: "gpt-4o-2024-08-06",
        messages: [{"role" => "user", "content" => "Hello"}]
      )

      response.rate_limit.try(&.reset_tokens).should eq(reset_tokens)
      response.data.should be_a(Niki::Completion)

      response.data.try do |completion|
        completion.id.should eq(completion_id)
      end

      response.object.should eq(object)
    end
  end

  describe "#update" do
    it "updates completion" do
      api_key = "x7y8z9"
      completion_id = "chatcmpl-abc123"

      body = <<-JSON
        {
          "id": "#{completion_id}",
          "object": "chat.completion",
          "created": 1738960610,
          "model": "gpt-4o-2024-08-06",
          "choices": [],
          "usage": {
            "total_tokens": 0,
            "completion_tokens": 0,
            "prompt_tokens": 0
          }
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/chat/completions/#{completion_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.completions.update(completion_id)

      response.data.should be_a(Niki::Completion)
    end
  end

  describe "#delete" do
    it "deletes completion" do
      api_key = "x7y8z9"
      completion_id = "chatcmpl-abc123"

      body = <<-JSON
        {
          "id": "#{completion_id}",
          "object": "chat.completion.deleted",
          "deleted": true
        }
        JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/chat/completions/#{completion_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.completions.delete(completion_id)

      response.data.should be_a(Niki::Completion)

      response.data.try do |completion|
        completion.deleted?.should be_true
      end
    end
  end
end

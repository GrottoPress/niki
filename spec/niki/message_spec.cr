require "../spec_helper"

describe Niki::Message::Endpoint do
  describe "#fetch" do
    it "retrieves message" do
      api_key = "x7y8z9"
      object = "response"
      message_id = "resp_67cb71b351908190a308f3859487620d06981a8637e6bc44"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{message_id}",
          "object": "#{object}",
          "created_at": 1741386163,
          "status": "completed",
          "completed_at": 1741386164,
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "model": "gpt-4o-2024-08-06",
          "output": [
            {
              "type": "message",
              "id": "msg_67cb71b3c2b0819084d481baaaf148f206981a8637e6bc44",
              "status": "completed",
              "role": "assistant",
              "content": [
                {
                  "type": "output_text",
                  "text": "Silent circuits hum, Thoughts...",
                  "annotations": []
                }
              ]
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "reasoning": {
            "effort": null,
            "summary": null
          },
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "text"
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": {
            "input_tokens": 32,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 18,
            "output_tokens_details": {
              "reasoning_tokens": 0
            },
            "total_tokens": 50
          },
          "user": null,
          "metadata": {}
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/responses/#{message_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.messages.fetch(message_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Message)
      response.object.should eq(object)

      response.data.try do |data|
        data.output.try(&.first?).should be_a(Niki::Message::Output)
        data.usage.should be_a(Niki::Usage)

        data.output.try &.first?.try do |output|
          output.type.should eq(Niki::Message::Output::Type::Message)
          output.content.try(&.first?).should be_a(Niki::Message::Content)

          output.content.try &.first?.try do |content|
            content.type.should eq(Niki::Message::Content::Type::OutputText)
          end
        end
      end
    end
  end

  describe "#create" do
    it "creates message" do
      api_key = "x7y8z9"
      model = "gpt-5.4"
      reset_tokens = "6m0s"

      body = <<-JSON
        {
          "id": "resp_67ccd2bed1ec8190b14f964abc0542670bb6a6b452d3795b",
          "object": "response",
          "created_at": 1741476542,
          "status": "completed",
          "completed_at": 1741476543,
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "model": "#{model}",
          "output": [
            {
              "type": "message",
              "id": "msg_67ccd2bf17f0819081ff3bb2cf6508e60bb6a6b452d3795b",
              "status": "completed",
              "role": "assistant",
              "content": [
                {
                  "type": "output_text",
                  "text": "In a peaceful grove beneath a silver moon...",
                  "annotations": []
                }
              ]
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "reasoning": {
            "effort": null,
            "summary": null
          },
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "text"
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": {
            "input_tokens": 36,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 87,
            "output_tokens_details": {
              "reasoning_tokens": 0
            },
            "total_tokens": 123
          },
          "user": null,
          "metadata": {}
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/responses")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-Ratelimit-reset-Tokens" => reset_tokens
        })

      client = Niki.new(api_key)

      response = client.messages.create(
        model: model,
        input: "Tell me a three sentence bedtime story about a unicorn."
      )

      response.rate_limit.try(&.reset_tokens).should eq(reset_tokens)
      response.data.should be_a(Niki::Message)

      response.data.try do |data|
        data.output.try(&.first?).should be_a(Niki::Message::Output)
        data.model.should eq(model)
        data.usage.should be_a(Niki::Usage)

        data.output.try &.first?.try do |output|
          output.type.should eq(Niki::Message::Output::Type::Message)
          output.content.try(&.first?).should be_a(Niki::Message::Content)

          output.content.try &.first?.try do |content|
            content.type.should eq(Niki::Message::Content::Type::OutputText)
          end
        end
      end
    end
  end

  describe "#input_tokens" do
    it "returns token count" do
      api_key = "x7y8z9"
      organization_id = "a1b2c3"
      remaining_requests = 456

      body = <<-'JSON'
        {
          "object": "response.input_tokens",
          "input_tokens": 11
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/responses/input_tokens")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "openai-organization" => organization_id,
          "x-ratelimit-remaining-requests" => remaining_requests.to_s
        })

      client = Niki.new(api_key)

      response = client.messages.input_tokens(
        model: "gpt-5",
        input: "Tell me a joke."
      )

      response.organization.should eq(organization_id)
      response.data.should be_a(Niki::Usage)

      response.rate_limit
        .try(&.remaining_requests)
        .should(eq remaining_requests)
    end
  end

  describe "#delete" do
    it "deletes message" do
      api_key = "x7y8z9"
      message_id = "resp_6786a1bec27481909a17d673315b29f6"

      body = <<-JSON
        {
          "id": "#{message_id}",
          "object": "response",
          "deleted": true
        }
        JSON

      WebMock.stub(:DELETE, "https://api.openai.com/v1/responses/#{message_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.messages.delete(message_id)

      response.data.should be_a(Niki::Message)

      response.data.try do |data|
        data.deleted?.should be_true
      end
    end
  end

  describe "#cancel" do
    it "cancels message" do
      api_key = "x7y8z9"
      function_name = "get_weather"
      message_id = "resp_67cb71b351908190a308f3859487620d06981a8637e6bc44"

      body = <<-JSON
        {
          "id": "#{message_id}",
          "object": "response",
          "created_at": 1741386163,
          "status": "cancelled",
          "background": true,
          "completed_at": null,
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "model": "gpt-4o-2024-08-06",
          "output": [
            {
              "arguments": "{\\"location\\":\\"Paris, France\\"}",
              "call_id": "call_2345abc",
              "name": "#{function_name}",
              "type": "function_call"
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "reasoning": {
            "effort": null,
            "summary": null
          },
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "text"
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": null,
          "user": null,
          "metadata": {}
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/responses/#{message_id}/cancel"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.messages.cancel(message_id)

      response.data.should be_a(Niki::Message)

      response.data.try do |message|
        message.output.should be_a(Array(Niki::Message::Output))

        message.output.try &.each do |output|
          output.arguments.should eq({"location" => "Paris, France"})
          output.name.should eq(function_name)
          output.type.should eq(Niki::Message::Output::Type::FunctionCall)
        end
      end
    end
  end

  describe "#compact" do
    it "compacts response" do
      api_key = "x7y8z9"

      body = <<-JSON
        {
          "id": "resp_001",
          "object": "response.compaction",
          "created_at": 1764967971,
          "output": [
            {
              "id": "msg_000",
              "type": "message",
              "status": "completed",
              "content": [
                {
                  "type": "input_text",
                  "text": "Create a simple landing page for a dog petting cafe."
                }
              ],
              "role": "user"
            },
            {
              "id": "cmp_001",
              "type": "compaction",
              "encrypted_content": "gAAAAABpM0Yj-...="
            }
          ],
          "usage": {
            "input_tokens": 139,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 438,
            "output_tokens_details": {
              "reasoning_tokens": 64
            },
            "total_tokens": 577
          }
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/responses/compact")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.messages.compact

      response.data.should be_a(Niki::Message)
    end
  end
end

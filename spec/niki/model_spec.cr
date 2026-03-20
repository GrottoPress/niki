require "../spec_helper"

describe Niki::Model::Endpoint do
  describe "#fetch" do
    it "retrieves model" do
      api_key = "x7y8z9"
      model_id = "gpt-4o-2024-08-06"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{model_id}",
          "object": "model",
          "created": 1722475520,
          "owned_by": "system"
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/models/#{model_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.models.fetch(model_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Model)

      response.data.try do |model|
        model.id.should eq(model_id)
        model.created.should eq(1722475520)
        model.owned_by.should eq("system")
      end
    end
  end

  describe "#list" do
    it "lists models" do
      api_key = "x7y8z9"
      model_id = "gpt-4o-2024-08-06"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{model_id}",
              "object": "model",
              "created": 1722475520,
              "owned_by": "system"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/models")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.models.list

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::Model))

      response.data.try &.first?.try do |model|
        model.id.should eq(model_id)
      end
    end
  end

  describe "#delete" do
    it "deletes model" do
      api_key = "x7y8z9"
      model_id = "gpt-4o-2024-08-06"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{model_id}",
          "object": "model",
          "deleted": true
        }
        JSON

      WebMock.stub(:DELETE, "https://api.openai.com/v1/models/#{model_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.models.delete(model_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Model)

      response.data.try do |model|
        model.id.should eq(model_id)
        model.deleted?.should be_true
      end
    end
  end
end

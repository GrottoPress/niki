require "../spec_helper"

describe Niki::Container::Endpoint do
  describe "#fetch" do
    it "retrieves container" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{container_id}",
          "object": "container",
          "name": "my-container",
          "status": "active",
          "created_at": 1722475520,
          "last_active_at": 1722475600,
          "expires_after": {
            "anchor": "last_active_at",
            "minutes": 60
          },
          "memory_limit": "4g",
          "network_policy": {
            "type": "allowlist",
            "allowed_domains": ["api.openai.com"]
          }
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/containers/#{container_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.fetch(container_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container)

      response.data.try do |container|
        container.id.should eq(container_id)
        container.name.should eq("my-container")
        container.status.should eq("active")
        container.memory_limit.should eq("4g")
        container.expires_after.try(&.anchor).should eq("last_active_at")
        container.expires_after.try(&.minutes).should eq(60)

        container.network_policy
          .try(&.type)
          .should(eq Niki::Container::NetworkPolicy::Type::Allowlist)
      end
    end
  end

  describe "#list" do
    it "lists containers" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{container_id}",
              "object": "container",
              "name": "my-container",
              "status": "active",
              "created_at": 1722475520,
              "last_active_at": 1722475600
            }
          ],
          "first_id": "#{container_id}",
          "last_id": "#{container_id}",
          "has_more": false
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/containers")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.list

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::Container))

      response.data.try &.first?.try do |container|
        container.id.should eq(container_id)
        container.name.should eq("my-container")
        container.status.should eq("active")
      end
    end
  end

  describe "#create" do
    it "creates container" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{container_id}",
          "object": "container",
          "name": "my-container",
          "status": "active",
          "created_at": 1722475520
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/containers")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.create(name: "my-container")

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container)

      response.data.try do |container|
        container.id.should eq(container_id)
        container.name.should eq("my-container")
      end
    end
  end

  describe "#delete" do
    it "deletes container" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{container_id}",
          "object": "container",
          "deleted": true
        }
        JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/containers/#{container_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.delete(container_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container)

      response.data.try do |container|
        container.id.should eq(container_id)
        container.deleted?.should be_true
      end
    end
  end
end

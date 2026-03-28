require "../spec_helper"

describe Niki::Skill::Endpoint do
  describe "#fetch" do
    it "retrieves skill" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{skill_id}",
          "object": "skill",
          "created_at": 1722475520,
          "default_version": "v1",
          "description": "CSV insights helper",
          "latest_version": "v1",
          "name": "csv_insights"
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/skills/#{skill_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.fetch(skill_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill)

      response.data.try do |skill|
        skill.id.should eq(skill_id)
        skill.name.should eq("csv_insights")
        skill.description.should eq("CSV insights helper")
        skill.default_version.should eq("v1")
        skill.latest_version.should eq("v1")
      end
    end
  end

  describe "#list" do
    it "lists skills" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{skill_id}",
              "object": "skill",
              "created_at": 1722475520,
              "default_version": "v1",
              "description": "CSV insights helper",
              "latest_version": "v1",
              "name": "csv_insights"
            }
          ],
          "first_id": "#{skill_id}",
          "has_more": false,
          "last_id": "#{skill_id}"
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/skills")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.list

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::Skill))
      response.first_id.should eq(skill_id)
      response.has_more?.should be_false

      response.data.try &.first?.try do |skill|
        skill.id.should eq(skill_id)
        skill.name.should eq("csv_insights")
      end
    end
  end

  describe "#create" do
    it "uploads skill" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{skill_id}",
          "object": "skill",
          "created_at": 1722475520,
          "default_version": "v1",
          "description": "CSV insights helper",
          "latest_version": "v1",
          "name": "csv_insights"
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/skills")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)

      source = File.tempfile("niki", ".zip")

      begin
        response = client.skills.upload(source.path)

        response.rate_limit.try(&.reset_requests).should eq(reset_requests)
        response.data.should be_a(Niki::Skill)

        response.data.try do |skill|
          skill.id.should eq(skill_id)
          skill.name.should eq("csv_insights")
          skill.description.should eq("CSV insights helper")
          skill.default_version.should eq("v1")
          skill.latest_version.should eq("v1")
        end
      ensure
        source.delete
      end
    end
  end

  describe "#update" do
    it "updates skill" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{skill_id}",
          "object": "skill",
          "created_at": 1722475520,
          "default_version": "v2",
          "description": "CSV insights helper",
          "latest_version": "v2",
          "name": "csv_insights"
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/skills/#{skill_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.update(skill_id, default_version: "v2")

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill)

      response.data.try do |skill|
        skill.id.should eq(skill_id)
        skill.default_version.should eq("v2")
      end
    end
  end

  describe "#delete" do
    it "deletes skill" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{skill_id}",
          "object": "skill.deleted",
          "deleted": true
        }
        JSON

      WebMock.stub(:DELETE, "https://api.openai.com/v1/skills/#{skill_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.delete(skill_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill)

      response.data.try do |skill|
        skill.id.should eq(skill_id)
        skill.deleted?.should be_true
      end
    end
  end

  describe "#content" do
    it "downloads skill content" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      skill_content = "niki"
      reset_requests = "1s"

      body_io = IO::Memory.new(skill_content)

      WebMock.stub(:GET, "https://api.openai.com/v1/skills/#{skill_id}/content")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body_io: body_io, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      destination = IO::Memory.new

      client = Niki.new(api_key)
      response = client.skills.download(skill_id, destination)

      destination.gets_to_end.should eq(skill_content)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_nil
    end
  end
end

require "../../spec_helper"

describe Niki::Skill::Version::Endpoint do
  describe "#fetch" do
    it "retrieves skill version" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      version_id = "sv_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{version_id}",
          "object": "skill.version",
          "created_at": 1722475520,
          "description": "First release",
          "name": "v1",
          "skill_id": "#{skill_id}",
          "version": "v1"
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/skills/#{skill_id}/versions/#{version_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.versions.fetch(skill_id, version_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill::Version)

      response.data.try do |version|
        version.id.should eq(version_id)
        version.skill_id.should eq(skill_id)
        version.version.should eq("v1")
        version.name.should eq("v1")
      end
    end
  end

  describe "#list" do
    it "lists skill versions" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      version_id = "sv_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{version_id}",
              "object": "skill.version",
              "created_at": 1722475520,
              "description": "First release",
              "name": "v1",
              "skill_id": "#{skill_id}",
              "version": "v1"
            }
          ],
          "first_id": "#{version_id}",
          "has_more": false,
          "last_id": "#{version_id}"
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/skills/#{skill_id}/versions"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.versions.list(skill_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::Skill::Version))
      response.first_id.should eq(version_id)
      response.has_more?.should be_false

      response.data.try &.first?.try do |version|
        version.id.should eq(version_id)
        version.skill_id.should eq(skill_id)
        version.version.should eq("v1")
        version.name.should eq("v1")
      end
    end
  end

  describe "#create" do
    it "uploads skill version" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      version_id = "sv_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{version_id}",
          "object": "skill.version",
          "created_at": 1722475520,
          "description": "Second release",
          "name": "v2",
          "skill_id": "#{skill_id}",
          "version": "v2"
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/skills/#{skill_id}/versions"
      )
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)

      tempfile = File.tempfile("niki", ".zip")
      response = client.skills.versions.upload(skill_id, tempfile.path)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill::Version)

      response.data.try do |version|
        version.id.should eq(version_id)
        version.skill_id.should eq(skill_id)
        version.version.should eq("v2")
        version.name.should eq("v2")
      end
    end
  end

  describe "#delete" do
    it "deletes skill version" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      version_id = "sv_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{version_id}",
          "object": "skill.version.deleted",
          "deleted": true
        }
        JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/skills/#{skill_id}/versions/#{version_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests,
        })

      client = Niki.new(api_key)
      response = client.skills.versions.delete(skill_id, version_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Skill::Version)

      response.data.try do |version|
        version.id.should eq(version_id)
        version.deleted?.should be_true
      end
    end
  end

  describe "#content" do
    it "downloads skill version content" do
      api_key = "x7y8z9"
      skill_id = "skill_abc123"
      version_id = "sv_xyz789"
      version_content = "niki"
      reset_requests = "1s"

      body_io = IO::Memory.new(version_content)

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/skills/#{skill_id}/versions\
          /#{version_id}/content"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body_io: body_io, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      destination = IO::Memory.new

      client = Niki.new(api_key)

      response = client.skills.versions.download(
        skill_id,
        version_id,
        destination
      )

      destination.gets_to_end.should eq(version_content)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_nil
    end
  end
end

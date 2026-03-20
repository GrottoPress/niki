require "../spec_helper"

describe Niki::File::Endpoint do
  describe "#fetch" do
    it "retrieves file" do
      api_key = "x7y8z9"
      file_id = "file-abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "file",
          "bytes": 1024,
          "created_at": 1722475520,
          "filename": "test.jsonl",
          "purpose": "batch"
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/files/#{file_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.files.fetch(file_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.bytes.should eq(1024)
        file.filename.should eq("test.jsonl")
        file.purpose.should eq("batch")
      end
    end
  end

  describe "#list" do
    it "lists files" do
      api_key = "x7y8z9"
      file_id = "file-abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{file_id}",
              "object": "file",
              "bytes": 1024,
              "created_at": 1722475520,
              "filename": "test.jsonl",
              "purpose": "batch"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/files")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.files.list

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::File))

      response.data.try &.first?.try do |file|
        file.id.should eq(file_id)
      end
    end
  end

  describe "#create" do
    it "uploads file" do
      api_key = "x7y8z9"
      file_id = "file-abc123"
      file_name = "test.jsonl"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "file",
          "bytes": 1024,
          "created_at": 1722475520,
          "filename": "#{file_name}",
          "purpose": "batch"
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/files")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      tempfile = File.tempfile("niki", ".txt")

      client = Niki.new(api_key)
      response = client.files.upload(tempfile.path)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.bytes.should eq(1024)
        file.filename.should eq(file_name)
        file.purpose.should eq("batch")
      end
    end
  end

  describe "#delete" do
    it "deletes file" do
      api_key = "x7y8z9"
      file_id = "file-abc123"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "file",
          "deleted": true
        }
        JSON

      WebMock.stub(:DELETE, "https://api.openai.com/v1/files/#{file_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.files.delete(file_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.deleted?.should be_true
      end
    end
  end

  describe "#content" do
    it "downloads file" do
      api_key = "x7y8z9"
      file_id = "file-abc123"
      file_content = "niki"
      reset_requests = "1s"

      body_io = IO::Memory.new(file_content)

      WebMock.stub(:GET, "https://api.openai.com/v1/files/#{file_id}/content")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body_io: body_io, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      destination = IO::Memory.new

      client = Niki.new(api_key)
      response = client.files.download(file_id, destination)

      destination.gets_to_end.should eq(file_content)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_nil
    end
  end
end

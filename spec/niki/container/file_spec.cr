require "../../spec_helper"

describe Niki::Container::File::Endpoint do
  describe "#fetch" do
    it "retrieves container file" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "container.file",
          "bytes": 1024,
          "container_id": "#{container_id}",
          "created_at": 1722475520,
          "path": "/mnt/data/file.txt",
          "source": "user"
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/containers/#{container_id}/files/#{file_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.files.fetch(container_id, file_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.container_id.should eq(container_id)
        file.path.should eq("/mnt/data/file.txt")
      end
    end
  end

  describe "#list" do
    it "lists container files" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "object": "list",
          "data": [
            {
              "id": "#{file_id}",
              "object": "container.file",
              "bytes": 1024,
              "container_id": "#{container_id}",
              "created_at": 1722475520,
              "path": "/mnt/data/file.txt",
              "source": "user"
            }
          ],
          "first_id": "#{file_id}",
          "last_id": "#{file_id}",
          "has_more": false
        }
        JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/containers/#{container_id}/files"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.files.list(container_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Array(Niki::Container::File))

      response.data.try &.first?.try do |file|
        file.id.should eq(file_id)
        file.container_id.should eq(container_id)
        file.path.should eq("/mnt/data/file.txt")
      end
    end
  end

  describe "#create" do
    it "creates file in container" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "container.file",
          "bytes": 1024,
          "container_id": "#{container_id}",
          "created_at": 1722475520,
          "path": "/mnt/data/file.txt",
          "source": "user"
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/containers/#{container_id}/files"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)

      response = client.containers.files.create(
        container_id,
        file_id: "file.txt"
      )

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.container_id.should eq(container_id)
      end
    end

    it "uploads file to container" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "container.file",
          "bytes": 1024,
          "container_id": "#{container_id}",
          "created_at": 1722475520,
          "path": "/mnt/data/file.txt",
          "source": "user"
        }
        JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/containers/#{container_id}/files"
      )
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      source = File.tempfile("niki", ".txt")

      begin
        client = Niki.new(api_key)
        response = client.containers.files.upload(container_id, source.path)

        response.rate_limit.try(&.reset_requests).should eq(reset_requests)
        response.data.should be_a(Niki::Container::File)

        response.data.try do |file|
          file.id.should eq(file_id)
          file.container_id.should eq(container_id)
        end
      ensure
        source.delete
      end
    end
  end

  describe "#delete" do
    it "deletes container file" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      reset_requests = "1s"

      body = <<-JSON
        {
          "id": "#{file_id}",
          "object": "container.file",
          "deleted": true
        }
        JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/containers/#{container_id}/files/#{file_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body, headers: {
          "x-ratelimit-reset-requests" => reset_requests
        })

      client = Niki.new(api_key)
      response = client.containers.files.delete(container_id, file_id)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_a(Niki::Container::File)

      response.data.try do |file|
        file.id.should eq(file_id)
        file.deleted?.should be_true
      end
    end
  end

  describe "#content" do
    it "downloads container file" do
      api_key = "x7y8z9"
      container_id = "cntr_abc123"
      file_id = "cfile_xyz789"
      file_content = "niki"
      reset_requests = "1s"

      body_io = IO::Memory.new(file_content)

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/containers/#{container_id}/files\
          /#{file_id}/content"
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

      response = client.containers.files.download(
        container_id,
        file_id,
        destination
      )

      destination.gets_to_end.should eq(file_content)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_nil
    end
  end
end

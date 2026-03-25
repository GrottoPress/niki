require "../spec_helper"

describe Niki::Video::Endpoint do
  describe "#fetch" do
    it "retrieves video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
        {
          "id": "#{video_id}",
          "completed_at": 0,
          "created_at": 0,
          "expires_at": 0,
          "model": "string",
          "object": "video",
          "progress": 0,
          "prompt": "A calico cat playing a piano",
          "remixed_from_video_id": "remixed_from_video_id",
          "seconds": "seconds",
          "size": "720x1280",
          "status": "queued"
        }
        JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/videos/#{video_id}")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.fetch(video_id)

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq(video_id)
        video.status.should eq(Niki::Message::Status::Queued)
        video.prompt.should eq("A calico cat playing a piano")
      end
    end
  end

  describe "#list" do
    it "lists videos" do
      api_key = "x7y8z9"

      body = <<-JSON
      {
        "object": "list",
        "data": [
          {
            "id": "video_abc123",
            "object": "video",
            "created_at": 1712697600,
            "model": "sora-2",
            "status": "completed",
            "prompt": "A calico cat playing a piano"
          }
        ],
        "first_id": "video_abc123",
        "last_id": "video_abc123",
        "has_more": false
      }
      JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/videos")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.list

      response.data.should be_a(Array(Niki::Video))

      response.data.try &.first?.try do |video|
        video.id.should eq("video_abc123")
        video.status.should eq(Niki::Message::Status::Completed)
        video.model.should eq("sora-2")
      end
    end
  end

  describe "#create" do
    it "creates video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
        {
          "id": "#{video_id}",
          "object": "video",
          "model": "sora-2",
          "status": "queued",
          "progress": 0,
          "created_at": 1712697600,
          "size": "1024x1792",
          "seconds": "8",
          "quality": "standard"
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/videos")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      client = Niki.new(api_key)

      response = client.videos.create(
        prompt: "A cool cat on a motorcycle",
        model: "sora-2"
      )

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq(video_id)
        video.status.should eq(Niki::Message::Status::Queued)
      end
    end
  end

  describe "#delete" do
    it "deletes video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
      {
        "id": "#{video_id}",
        "deleted": true,
        "object": "video"
      }
      JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/videos/#{video_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.delete(video_id)

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq(video_id)
        video.deleted?.should be_true
      end
    end
  end

  describe "#content" do
    it "downloads video content" do
      api_key = "x7y8z9"
      video_id = "video_abc123"
      video_content = "binary video data"
      reset_requests = "1s"

      body_io = IO::Memory.new(video_content)

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/videos/#{video_id}/content"
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
      response = client.videos.download(video_id, destination)

      destination.gets_to_end.should eq(video_content)

      response.rate_limit.try(&.reset_requests).should eq(reset_requests)
      response.data.should be_nil
    end
  end

  describe "#extend" do
    it "extends a video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
        {
          "id": "video_extended",
          "object": "video",
          "model": "sora-2",
          "status": "queued",
          "prompt": "Continue the scene...",
          "seconds": "8"
        }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/videos/extensions")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.extend(video_id, prompt: "Continue the scene...", seconds: "8")

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq("video_extended")
        video.status.should eq(Niki::Message::Status::Queued)
      end
    end
  end

  describe "#edit" do
    it "edits a video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
        {
          "id": "video_edited",
          "object": "video",
          "model": "sora-2",
          "status": "queued",
          "prompt": "Make it sunset"
        }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/videos/edits")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.edit(video_id, prompt: "Make it sunset")

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq("video_edited")
        video.status.should eq(Niki::Message::Status::Queued)
      end
    end
  end

  describe "#remix" do
    it "remixes a video" do
      api_key = "x7y8z9"
      video_id = "video_abc123"

      body = <<-JSON
        {
          "id": "video_remixed",
          "object": "video",
          "model": "sora-2",
          "status": "queued",
          "prompt": "Remix with a different style"
        }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/videos/#{video_id}/remix")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.remix(video_id, prompt: "Remix with a different style")

      response.data.should be_a(Niki::Video)

      response.data.try do |video|
        video.id.should eq("video_remixed")
        video.status.should eq(Niki::Message::Status::Queued)
      end
    end
  end
end

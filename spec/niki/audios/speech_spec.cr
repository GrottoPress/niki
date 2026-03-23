require "../../spec_helper"

describe Niki::Audio::Speech::Endpoint do
  describe "#create" do
    it "creates speech" do
      api_key = "x7y8z9"
      file_content = "niki"

      body_io = IO::Memory.new(file_content)

      WebMock.stub(:POST, "https://api.openai.com/v1/audio/speech")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "Content-Type" => "application/json"
        })
        .to_return(body_io: body_io)

      destination = IO::Memory.new

      client = Niki.new(api_key)
      response = client.audios.speeches.create(destination)

      destination.gets_to_end.should eq(file_content)
      response.data.should be_nil
    end
  end
end

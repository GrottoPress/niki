require "../../spec_helper"

describe Niki::Audio::Voice::Endpoint do
  describe "#create" do
    it "creates voice" do
      api_key = "x7y8z9"
      object = "audio.voice"

      body = <<-JSON
      {
        "id": "id",
        "created_at": 0,
        "name": "name",
        "object": "#{object}"
      }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/audio/voices")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      source = File.tempfile("sample", ".mp3")

      begin
        client = Niki.new(api_key)
        response = client.audios.voices.create(source.path)

        response.object.should eq(object)
        response.data.should be_a(Niki::Audio::Voice)

        response.data.try do |voice|
          voice.id.should eq("id")
        end
      ensure
        source.delete
      end
    end
  end
end

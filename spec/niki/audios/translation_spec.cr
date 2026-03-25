require "../../spec_helper"

describe Niki::Audio::Translation::Endpoint do
  describe "#create" do
    it "creates translation" do
      api_key = "x7y8z9"

      body = <<-JSON
        {
          "text": "Hello, my name is Wolfgang and I come from Germany."
        }
        JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/audio/translations")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      tempfile = File.tempfile("audio", ".mp3")

      client = Niki.new(api_key)
      response = client.audios.translations.create(
        tempfile.path,
        model: Niki::Model::WHISPER_1
      )

      response.data.should be_a(Niki::Audio::Translation)

      response.data.try do |translation|
        translation.text.should be_a(String)
      end

      tempfile.delete
    end
  end
end

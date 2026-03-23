require "../../spec_helper"

describe Niki::Audio::Transcription::Endpoint do
  describe "#create" do
    it "creates transcription" do
      api_key = "x7y8z9"

      body = <<-JSON
      {
        "text": "Imagine the wildest idea that you've ever had...",
        "usage": {
          "type": "tokens",
          "input_tokens": 14,
          "input_token_details": {
            "text_tokens": 0,
            "audio_tokens": 14
          },
          "output_tokens": 45,
          "total_tokens": 59
        }
      }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/audio/transcriptions")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      tempfile = File.tempfile("audio", ".mp3")

      client = Niki.new(api_key)

      response = client.audios.transcriptions.create(
        tempfile.path,
        model: "gpt-4o-transcribe"
      )

      response.data.should be_a(Niki::Audio::Transcription)

      response.data.try do |transcription|
        transcription.text.should be_a(String)
        transcription.usage.should be_a(Niki::Usage)
      end
    end
  end
end

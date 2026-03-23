require "../../spec_helper"

describe Niki::Audio::Consent::Endpoint do
  describe "#fetch" do
    it "retrieves voice consent" do
      api_key = "x7y8z9"
      consent_id = "cons_abc123"

      body = <<-JSON
      {
        "id": "#{consent_id}",
        "created_at": 0,
        "language": "en",
        "name": "name",
        "object": "audio.voice_consent"
      }
      JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/audio/voice_consents/#{consent_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.audios.consents.fetch(consent_id)

      response.data.should be_a(Niki::Audio::Consent)

      response.data.try do |consent|
        consent.id.should eq(consent_id)
        consent.name.should eq("name")
        consent.language.should eq("en")
      end
    end
  end

  describe "#list" do
    it "lists voice consents" do
      api_key = "x7y8z9"

      body = <<-JSON
      {
        "object": "list",
        "data": [
          {
            "id": "cons_abc123",
            "object": "audio.voice_consent",
            "name": "John Doe",
            "language": "en",
            "created_at": 1722475520
          }
        ]
      }
      JSON

      WebMock.stub(:GET, "https://api.openai.com/v1/audio/voice_consents")
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.audios.consents.list

      response.data.should be_a(Array(Niki::Audio::Consent))

      response.data.try &.first?.try do |consent|
        consent.id.should eq("cons_abc123")
        consent.name.should eq("John Doe")
        consent.language.should eq("en")
      end
    end
  end

  describe "#create" do
    it "creates voice consent" do
      api_key = "x7y8z9"
      object = "audio.voice_consent"

      body = <<-JSON
      {
        "id": "id",
        "created_at": 0,
        "name": "John Doe",
        "language": "en",
        "object": "#{object}"
      }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/audio/voice_consents")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      tempfile = File.tempfile("recording", ".wav")

      client = Niki.new(api_key)

      response = client.audios.consents.create(
        tempfile.path,
        name: "John Doe",
        language: "en"
      )

      response.object.should eq(object)
      response.data.should be_a(Niki::Audio::Consent)

      response.data.try do |consent|
        consent.id.should eq("id")
        consent.name.should eq("John Doe")
        consent.language.should eq("en")
      end

      tempfile.delete
    end
  end

  describe "#update" do
    it "updates voice consent" do
      api_key = "x7y8z9"
      consent_id = "cons_abc123"

      body = <<-JSON
      {
        "id": "#{consent_id}",
        "created_at": 0,
        "language": "en",
        "name": "name",
        "object": "audio.voice_consent"
      }
      JSON

      WebMock.stub(
        :POST,
        "https://api.openai.com/v1/audio/voice_consents/#{consent_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.audios.consents.update(consent_id)

      response.data.should be_a(Niki::Audio::Consent)

      response.data.try do |consent|
        consent.id.should eq(consent_id)
        consent.name.should eq("name")
      end
    end
  end

  describe "#delete" do
    it "deletes voice consent" do
      api_key = "x7y8z9"
      consent_id = "cons_abc123"

      body = <<-JSON
      {
        "id": "#{consent_id}",
        "deleted": true,
        "object": "audio.voice_consent"
      }
      JSON

      WebMock.stub(
        :DELETE,
        "https://api.openai.com/v1/audio/voice_consents/#{consent_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.audios.consents.delete(consent_id)

      response.data.should be_a(Niki::Audio::Consent)

      response.data.try do |consent|
        consent.id.should eq(consent_id)
        consent.deleted?.should be_true
      end
    end
  end
end

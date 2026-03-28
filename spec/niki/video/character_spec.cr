require "../../spec_helper"

describe Niki::Video::Character::Endpoint do
  describe "#fetch" do
    it "retrieves character" do
      api_key = "x7y8z9"
      character_id = "char_abc123"

      body = <<-JSON
      {
        "id": "#{character_id}",
        "created_at": 1712697600,
        "name": "Mossy"
      }
      JSON

      WebMock.stub(
        :GET,
        "https://api.openai.com/v1/videos/characters/#{character_id}"
      )
        .with(headers: {
          "Authorization" => "Bearer #{api_key}",
          "content-type" => "application/json"
        })
        .to_return(body: body)

      client = Niki.new(api_key)
      response = client.videos.characters.fetch(character_id)

      response.data.should be_a(Niki::Video::Character)

      response.data.try do |character|
        character.id.should eq(character_id)
        character.name.should eq("Mossy")
      end
    end
  end

  describe "#create" do
    it "creates character" do
      api_key = "x7y8z9"
      character_id = "char_abc123"

      body = <<-JSON
      {
        "id": "#{character_id}",
        "created_at": 1712697600,
        "name": "Mossy"
      }
      JSON

      WebMock.stub(:POST, "https://api.openai.com/v1/videos/characters")
        .with(headers: {"Authorization" => "Bearer #{api_key}"})
        .to_return(body: body)

      source = File.tempfile("character", ".mp4")

      begin
        client = Niki.new(api_key)
        response = client.videos.characters.create(source.path, name: "Mossy")

        response.data.should be_a(Niki::Video::Character)

        response.data.try do |character|
          character.id.should eq(character_id)
          character.name.should eq("Mossy")
        end
      ensure
        source.delete
      end
    end
  end
end

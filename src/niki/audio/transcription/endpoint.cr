struct Niki::Audio::Transcription::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(path, headers = nil, **params) : Item
    response = upload(uri.path, "file", path, headers, **params)
    Item.from_json(response)
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/audio/transcriptions" }
  end
end

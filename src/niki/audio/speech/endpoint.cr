struct Niki::Audio::Speech::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(destination : IO, headers = nil, **params) : Item
    @client.post(uri.path, headers, params.to_json) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap do |uri|
      uri.path += "/audio/speech"
    end
  end
end

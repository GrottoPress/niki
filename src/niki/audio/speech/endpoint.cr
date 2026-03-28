struct Niki::Audio::Speech::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(destination, headers = nil, **params) : Item
    @client.post(uri.path, headers, params.to_json) do |response|
      copy_io(response.body_io, destination)
      Item.from_json(response)
    end
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/audio/speech" }
  end
end

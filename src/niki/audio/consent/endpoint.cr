struct Niki::Audio::Consent::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def fetch(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.get(path, headers)

    Item.from_json(response)
  end

  def list(headers = nil, **params) : List
    resource = "#{uri.path}?#{URI::Params.encode(params)}"
    response = @client.get(resource, headers)

    List.from_json(response)
  end

  def create(path, headers = nil, **params) : Item
    response = upload(uri.path, "recording", path, headers, **params)
    Item.from_json(response)
  end

  def update(id : String, headers = nil, **params) : Item
    path = "#{uri.path}/#{id}"
    response = @client.post(path, headers, params.to_json)

    Item.from_json(response)
  end

  def delete(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.delete(path, headers)

    Item.from_json(response)
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/audio/voice_consents" }
  end
end

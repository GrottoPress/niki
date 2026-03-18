struct Niki::Conversation::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(headers = nil, **params) : Item
    response = @client.post(uri.path, headers, params.to_json)
    Item.from_json(response)
  end

  def fetch(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.get(path, headers)

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
    URI.parse(@client.uri.to_s).tap { |uri| uri.path += "/conversations" }
  end
end

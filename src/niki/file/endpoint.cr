struct Niki::File::Endpoint
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

  def upload(path, headers = nil, **params)
    create(path, headers, **params)
  end

  def create(path, headers = nil, **params) : Item
    response = upload(uri.path, "file", path, headers, **params)
    Item.from_json(response)
  end

  def delete(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.delete(path, headers)

    Item.from_json(response)
  end

  def download(id, destination, headers = nil)
    content(id, destination, headers)
  end

  def content(id : String, destination : IO, headers = nil) : Item
    path = "#{uri.path}/#{id}/content"

    @client.get(path, headers) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/files" }
  end
end

struct Niki::Skill::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def versions : Version::Endpoint
    Version::Endpoint.new(@client)
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

  def upload(path, headers = nil)
    create(path, headers)
  end

  def create(path, headers = nil) : Item
    response = upload(uri.path, "files", path, headers)
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

  def download(id, destination, headers = nil)
    content(id, destination, headers)
  end

  def content(id : String, destination, headers = nil) : Item
    path = "#{uri.path}/#{id}/content"

    @client.get(path, headers) do |response|
      copy_io(response.body_io, destination)
      Item.from_json(response)
    end
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/skills" }
  end
end

struct Niki::Video::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def characters : Character::Endpoint
    Character::Endpoint.new(@client)
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

  def create(headers = nil, **params) : Item
    text_headers = HTTP::Headers{"Content-Type" => "text/plain"}

    boundary = MIME::Multipart.generate_boundary
    io = IO::Memory.new

    headers ||= HTTP::Headers.new
    headers["Content-Type"] = %(multipart/form-data; boundary="#{boundary}")

    HTTP::FormData.build(io, boundary) do |form|
      params.each do |key, value|
        form.field(key.to_s, value.to_s, text_headers)
      end
    end

    response = @client.post(uri.path, headers, io.rewind)
    Item.from_json(response)
  end

  def delete(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.delete(path, headers)

    Item.from_json(response)
  end

  def edit(id : String, headers = nil, **params) : Item
    path = "#{uri.path}/edits"
    params = params.merge(video: {id: id})
    response = @client.post(path, headers, params.to_json)

    Item.from_json(response)
  end

  def extend(id : String, headers = nil, **params) : Item
    params = params.merge(video: {id: id})
    path = "#{uri.path}/extensions"
    response = @client.post(path, headers, params.to_json)

    Item.from_json(response)
  end

  def remix(id : String, headers = nil, **params) : Item
    path = "#{uri.path}/#{id}/remix"
    response = @client.post(path, headers, params.to_json)

    Item.from_json(response)
  end

  def download(id, destination, headers = nil, **params)
    content(id, destination, headers, **params)
  end

  def content(id : String, destination : IO, headers = nil, **params) : Item
    path = "#{uri.path}/#{id}/content?#{URI::Params.encode(params)}"

    @client.get(path, headers) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap { |uri| uri.path += "/videos" }
  end
end

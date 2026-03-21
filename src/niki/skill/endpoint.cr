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
    file_metadata = HTTP::FormData::FileMetadata.new(Path[path].basename)
    file_type = MIME.from_filename?(path) || "application/octet-stream"

    file_headers = HTTP::Headers{"Content-Type" => file_type}

    boundary = MIME::Multipart.generate_boundary
    io = IO::Memory.new

    headers ||= HTTP::Headers.new
    headers["Content-Type"] = %(multipart/form-data; boundary="#{boundary}")

    HTTP::FormData.build(io, boundary) do |form|
      ::File.open(path) do |file|
        form.file("files", file, file_metadata, file_headers)
      end
    end

    response = @client.post(uri.path, headers, io.rewind)
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

  def content(id : String, destination : IO, headers = nil) : Item
    path = "#{uri.path}/#{id}/content"

    @client.get(path, headers) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap { |uri| uri.path += "/skills" }
  end
end

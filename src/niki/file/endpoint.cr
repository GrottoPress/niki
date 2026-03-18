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
    file_metadata = HTTP::FormData::FileMetadata.new(Path[path].basename)
    file_type = MIME.from_filename?(path) || "application/octet-stream"

    file_headers = HTTP::Headers{"Content-Type" => file_type}
    text_headers = HTTP::Headers{"Content-Type" => "text/plain"}

    boundary = MIME::Multipart.generate_boundary
    io = IO::Memory.new

    headers ||= HTTP::Headers.new
    headers["Content-Type"] = %(multipart/form-data; boundary="#{boundary}")

    HTTP::FormData.build(io, boundary) do |form|
      params.each do |key, value|
        form.field(key.to_s, value.to_s, text_headers)
      end

      ::File.open(path) do |file|
        form.file("file", file, file_metadata, file_headers)
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
    URI.parse(@client.uri.to_s).tap { |uri| uri.path += "/files" }
  end
end

struct Niki::Container::File::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def fetch(container_id : String, file_id : String, headers = nil) : Item
    path = "#{uri(container_id).path}/#{file_id}"
    response = @client.get(path, headers)

    Item.from_json(response)
  end

  def list(container_id : String, headers = nil, **params) : List
    resource = "#{uri(container_id).path}?#{URI::Params.encode(params)}"
    response = @client.get(resource, headers)

    List.from_json(response)
  end

  def upload(container_id, path, headers = nil) : Item
    create(container_id, path, headers)
  end

  def create(container_id : String, path, headers = nil) : Item
    file_metadata = HTTP::FormData::FileMetadata.new(Path[path].basename)
    file_type = MIME.from_filename?(path) || "application/octet-stream"
    file_headers = HTTP::Headers{"Content-Type" => file_type}

    boundary = MIME::Multipart.generate_boundary
    io = IO::Memory.new

    headers ||= HTTP::Headers.new
    headers["Content-Type"] = %(multipart/form-data; boundary="#{boundary}")

    HTTP::FormData.build(io, boundary) do |form|
      ::File.open(path) do |file|
        form.file("file", file, file_metadata, file_headers)
      end
    end

    response = @client.post(uri(container_id).path, headers, io.rewind)
    Item.from_json(response)
  end

  def create(container_id : String, headers = nil, **params) : Item
    response = @client.post(uri(container_id).path, headers, params.to_json)
    Item.from_json(response)
  end

  def delete(container_id : String, file_id : String, headers = nil) : Item
    path = "#{uri(container_id).path}/#{file_id}"
    response = @client.delete(path, headers)

    Item.from_json(response)
  end

  def download(container_id, id, destination, headers = nil)
    content(container_id, id, destination, headers)
  end

  def content(
    container_id : String,
    file_id : String,
    destination : IO,
    headers = nil
  ) : Item
    path = "#{uri(container_id).path}/#{file_id}/content"

    @client.get(path, headers) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  def uri(container_id : String) : URI
    URI.parse(@client.containers.uri.to_s).tap do |uri|
      uri.path += "/#{container_id}/files"
    end
  end
end

struct Niki::Skill::Version::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def fetch(skill_id : String, version : String, headers = nil) : Item
    path = "#{uri(skill_id).path}/#{version}"
    response = @client.get(path, headers)

    Item.from_json(response)
  end

  def list(skill_id : String, headers = nil, **params) : List
    resource = "#{uri(skill_id).path}?#{URI::Params.encode(params)}"
    response = @client.get(resource, headers)

    List.from_json(response)
  end

  def upload(skill_id, path, headers = nil)
    create(skill_id, path, headers)
  end

  def create(skill_id : String, path, headers = nil) : Item
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

    response = @client.post(uri(skill_id).path, headers, io.rewind)

    Item.from_json(response)
  end

  def delete(skill_id : String, version : String, headers = nil) : Item
    path = "#{uri(skill_id).path}/#{version}"
    response = @client.delete(path, headers)

    Item.from_json(response)
  end

  def download(skill_id, version, destination, headers = nil)
    content(skill_id, version, destination, headers)
  end

  def content(skill_id : String, version : String, destination : IO, headers = nil) : Item
    path = "#{uri(skill_id).path}/#{version}/content"

    @client.get(path, headers) do |response|
      IO.copy(response.body_io, destination)
      destination.rewind
      Item.from_json(response)
    end
  end

  def uri(skill_id : String) : URI
    URI.parse(@client.skills.uri.to_s).tap do |uri|
      uri.path += "/#{skill_id}/versions"
    end
  end
end

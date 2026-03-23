struct Niki::Audio::Translation::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
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

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap do |uri|
      uri.path += "/audio/translations"
    end
  end
end

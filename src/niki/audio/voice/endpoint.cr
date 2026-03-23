struct Niki::Audio::Voice::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(sample, headers = nil, **params) : Item
    file_metadata = HTTP::FormData::FileMetadata.new(Path[sample].basename)
    file_type = MIME.from_filename?(sample) || "application/octet-stream"

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

      ::File.open(sample) do |file|
        form.file("audio_sample", file, file_metadata, file_headers)
      end
    end

    response = @client.post(uri.path, headers, io.rewind)
    Item.from_json(response)
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap do |uri|
      uri.path += "/audio/voices"
    end
  end
end

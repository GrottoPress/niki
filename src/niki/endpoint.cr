module Niki::Endpoint
  macro included
    @client : Niki

    private def upload(
      endpoint : String,
      field_name : String,
      path,
      headers = nil,
      **params
    )
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
          form.file(field_name, file, file_metadata, file_headers)
        end
      end

      @client.post(endpoint, headers, io.rewind)
    end
  end
end

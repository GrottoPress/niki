struct Niki::Embedding
  include Resource

  @embedding : String | Array(Float32) | Nil

  getter index : Int32?

  def vector : Array(Float32)?
    @embedding.try do |_embedding|
      next _embedding if _embedding.is_a?(Array)
      @embedding = base64_to_embedding(_embedding)
    end
  end

  private def base64_to_embedding(base64)
    bytes = Base64.decode(base64)
    float32_bytes = 4
    count = bytes.size // float32_bytes

    Array(Float32).new(count) do |i|
      slice = bytes[i * float32_bytes, float32_bytes]
      IO::ByteFormat::LittleEndian.decode(Float32, slice)
    end
  end
end

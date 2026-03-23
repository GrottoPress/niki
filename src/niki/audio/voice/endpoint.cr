struct Niki::Audio::Voice::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(sample, headers = nil, **params) : Item
    response = upload(uri.path, "audio_sample", sample, headers, **params)
    Item.from_json(response)
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap do |uri|
      uri.path += "/audio/voices"
    end
  end
end

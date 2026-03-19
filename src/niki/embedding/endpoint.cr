struct Niki::Embedding::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(headers = nil, **params) : List
    response = @client.post(uri.path, headers, params.to_json)
    List.from_json(response)
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s).tap { |uri| uri.path += "/embeddings" }
  end
end

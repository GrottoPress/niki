struct Niki::Embedding::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def create(headers = nil, **params) : List
    response = @client.post(uri.path, headers, params.to_json)
    List.from_json(response)
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/embeddings" }
  end
end

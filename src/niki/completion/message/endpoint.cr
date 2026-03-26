struct Niki::Completion::Message::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def list(completion_id : String, headers = nil, **params) : List
    resource = "#{uri(completion_id).path}?#{URI::Params.encode(params)}"
    response = @client.get(resource, headers)

    List.from_json(response)
  end

  def uri(completion_id : String) : URI
    clone_uri(@client.completions.uri).tap do |uri|
      uri.path += "/#{completion_id}/messages"
    end
  end
end

struct Niki::Message::InputItem::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def list(response_id : String, headers = nil, **params) : List
    resource = "#{uri(response_id).path}?#{URI::Params.encode(params)}"
    response = @client.get(resource, headers)

    List.from_json(response)
  end

  def uri(response_id : String) : URI
    clone_uri(@client.messages.uri).tap do |uri|
      uri.path += "/#{response_id}/input_items"
    end
  end
end

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
    response = upload(uri(skill_id).path, "files", path, headers)
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

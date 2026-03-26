struct Niki::Video::Character::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def fetch(id : String, headers = nil) : Item
    path = "#{uri.path}/#{id}"
    response = @client.get(path, headers)

    Item.from_json(response)
  end

  def create(video_path, headers = nil, **params) : Item
    response = upload(uri.path, "video", video_path, headers, **params)
    Item.from_json(response)
  end

  getter uri : URI do
    clone_uri(@client.videos.uri).tap { |uri| uri.path += "/characters" }
  end
end

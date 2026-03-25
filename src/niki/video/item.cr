struct Niki::Video::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Video? do
    return if error || json_unmapped.empty?
    Video.from_json(json_unmapped.to_json)
  end
end

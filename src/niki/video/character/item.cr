struct Niki::Video::Character::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Character? do
    return if error || json_unmapped.empty?
    Character.from_json(json_unmapped.to_json)
  end
end

struct Niki::Audio::Translation::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Translation? do
    return if error || json_unmapped.empty?
    Translation.from_json(json_unmapped.to_json)
  end
end

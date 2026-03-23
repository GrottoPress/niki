struct Niki::Audio::Voice::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Voice? do
    return if error || json_unmapped.empty?
    Voice.from_json(json_unmapped.to_json)
  end
end

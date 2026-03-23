struct Niki::Audio::Speech::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Speech? do
    return if error || json_unmapped.empty?
    Speech.from_json(json_unmapped.to_json)
  end
end

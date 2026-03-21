struct Niki::Skill::Version::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Version? do
    return if error || json_unmapped.empty?
    Version.from_json(json_unmapped.to_json)
  end
end

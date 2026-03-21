struct Niki::Skill::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Skill? do
    return if error || json_unmapped.empty?
    Skill.from_json(json_unmapped.to_json)
  end
end

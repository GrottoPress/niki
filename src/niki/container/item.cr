struct Niki::Container::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Container? do
    return if error || json_unmapped.empty?
    Container.from_json(json_unmapped.to_json)
  end
end

struct Niki::Container::File::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Niki::File? do
    return if error || json_unmapped.empty?
    Niki::File.from_json(json_unmapped.to_json)
  end
end

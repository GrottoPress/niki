struct Niki::File::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : File? do
    return if error || json_unmapped.empty?
    File.from_json(json_unmapped.to_json)
  end
end

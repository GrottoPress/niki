struct Niki::Model::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Model? do
    return if error || json_unmapped.empty?
    Model.from_json(json_unmapped.to_json)
  end
end

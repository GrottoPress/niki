struct Niki::Model::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Model? do
    return unless error.nil?
    Model.from_json(json_unmapped.to_json)
  end
end

struct Niki::Completion::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Completion? do
    return unless error.nil?
    Completion.from_json(json_unmapped.to_json)
  end
end

struct Niki::Usage::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Usage? do
    return unless error.nil?
    Usage.from_json(json_unmapped.to_json)
  end
end

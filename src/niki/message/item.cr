struct Niki::Message::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Message? do
    return unless error.nil?
    Message.from_json(json_unmapped.to_json)
  end
end

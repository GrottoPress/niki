struct Niki::Message::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Message? do
    return if error || json_unmapped.empty?
    Message.from_json(json_unmapped.to_json)
  end
end

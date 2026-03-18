struct Niki::Conversation::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Conversation? do
    return unless error.nil?
    Conversation.from_json(json_unmapped.to_json)
  end
end

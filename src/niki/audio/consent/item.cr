struct Niki::Audio::Consent::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Consent? do
    return if error || json_unmapped.empty?
    Consent.from_json(json_unmapped.to_json)
  end
end

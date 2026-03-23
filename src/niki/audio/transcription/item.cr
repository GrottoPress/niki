struct Niki::Audio::Transcription::Item
  include Response

  @[JSON::Field(ignore: true)]
  getter data : Transcription? do
    return if error || json_unmapped.empty?
    Transcription.from_json(json_unmapped.to_json)
  end
end

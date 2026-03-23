struct Niki::Audio::Endpoint
  include Niki::Endpoint

  def initialize(@client : Niki)
  end

  def speeches : Speech::Endpoint
    Speech::Endpoint.new(@client)
  end

  def transcriptions : Transcription::Endpoint
    Transcription::Endpoint.new(@client)
  end

  def translations : Translation::Endpoint
    Translation::Endpoint.new(@client)
  end

  def consents : Consent::Endpoint
    Consent::Endpoint.new(@client)
  end

  def voices : Voice::Endpoint
    Voice::Endpoint.new(@client)
  end
end

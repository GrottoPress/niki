struct Niki::Audio::Transcription
  enum Task
    Transcribe
  end

  include Resource

  @duration : Int32?

  getter language : String?
  getter logprobs : Array(LogProb)?
  getter segments : Array(Segment)?
  getter task : Task?
  getter text : String?
  getter usage : Usage?
  getter words : Array(Word)?

  def duration : Time::Span?
    @duration.try(&.seconds)
  end
end

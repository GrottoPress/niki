struct Niki::Audio::Translation
  include Resource

  @duration : Int32?

  getter language : String?
  getter segments : Array(Segment)?
  getter text : String?

  def duration : Time::Span?
    @duration.try(&.seconds)
  end
end

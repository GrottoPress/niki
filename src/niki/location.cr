struct Niki::Location
  enum Type
    Approximate
  end

  include Resource

  @timezone : String?

  getter city : String?
  getter country : String?
  getter region : String?

  def timezone : Time::Location?
    @timezone.try { |timezone| Time::Location.load(timezone) }
  end
end

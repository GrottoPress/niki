struct Niki::Audio::Consent::List
  include Response
  include Pagination

  getter data : Array(Consent)?
end

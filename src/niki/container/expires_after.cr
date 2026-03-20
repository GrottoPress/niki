struct Niki::Container::ExpiresAfter
  include Resource

  getter anchor : String?
  getter minutes : Int32?
end

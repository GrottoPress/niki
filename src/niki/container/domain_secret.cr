struct Niki::Container::DomainSecret
  include Resource

  getter domain : String
  getter name : String
  getter value : String
end

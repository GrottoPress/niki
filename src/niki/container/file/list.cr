struct Niki::Container::File::List
  include Response
  include Pagination

  getter data : Array(Niki::File)?
end

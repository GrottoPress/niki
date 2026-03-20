struct Niki::Container::List
  include Response
  include Pagination

  getter data : Array(Container)?
end

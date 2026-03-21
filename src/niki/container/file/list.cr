struct Niki::Container::File::List
  include Response
  include Pagination

  getter data : Array(File)?
end

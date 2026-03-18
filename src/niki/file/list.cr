struct Niki::File::List
  include Response
  include Pagination

  getter data : Array(File)?
end

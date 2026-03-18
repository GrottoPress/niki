struct Niki::Completion::List
  include Response
  include Pagination

  getter data : Array(Completion)?
end

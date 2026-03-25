struct Niki::Video::List
  include Response
  include Pagination

  getter data : Array(Video)?
end

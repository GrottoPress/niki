struct Niki::Skill::List
  include Response
  include Pagination

  getter data : Array(Skill)?
end

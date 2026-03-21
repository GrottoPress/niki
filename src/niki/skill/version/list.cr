struct Niki::Skill::Version::List
  include Response
  include Pagination

  getter data : Array(Version)?
end

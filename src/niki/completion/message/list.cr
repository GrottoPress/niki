struct Niki::Completion::Message::List
  include Response
  include Pagination

  getter data : Array(Message)?
end

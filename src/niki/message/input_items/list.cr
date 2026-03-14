struct Niki::Message::InputItem::List
  include Response
  include Pagination

  getter data : Array(Output)?
end

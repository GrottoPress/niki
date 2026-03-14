struct Niki::Tool::FileSearchFilter
  enum Type
    Eq
    Ne
    Gt
    Gte
    Lt
    Lte
  end

  include Resource

  getter key : String
  getter type : Type
  getter value : String | Int32 | Bool | Array(String | Int32)
end

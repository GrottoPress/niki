struct Niki::Tool::Format
  enum Syntax
    Lark
    Regex
  end

  enum Type
    Text
    Grammar
  end

  include Resource

  getter definition : String?
  getter syntax : Syntax?
  getter type : Type
end

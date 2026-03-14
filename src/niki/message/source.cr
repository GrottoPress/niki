struct Niki::Message::Source
  enum Type
    Url
  end

  include Resource

  getter type : Type
  getter url : String?
end

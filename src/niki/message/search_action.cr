struct Niki::Message::SearchAction
  enum Type
    Search
    OpenPage
    FindInPage
  end

  include Resource

  getter pattern : String?
  getter queries : Array(String)?
  getter sources : Array(Source)?
  getter text : String?
  getter type : Type
  getter url : String?
end

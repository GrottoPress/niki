struct Niki::Completion::ContentPart
  enum Type
    Text
    ImageUrl
  end

  include Resource

  getter image_url : Image?
  getter text : String?
  getter type : Type
end

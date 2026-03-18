struct Niki::Completion::Annotation
  include Resource

  getter type : Niki::Message::Annotation::Type
  getter url_citation : Niki::Message::Annotation?
end

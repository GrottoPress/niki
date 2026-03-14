struct Niki::Message::Annotation
  enum Type
    FileCitation
    UrlCitation
    ContainerFileCitation
    FilePath
  end

  include Resource

  getter container_id : String?
  getter end_index : Int32?
  getter file_id : String?
  getter filename : String?
  getter index : Int32?
  getter start_index : Int32?
  getter title : String?
  getter type : Type
  getter url : String?
end

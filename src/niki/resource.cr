module Niki::Resource
  enum Type
    Response
    Conversation
  end

  macro included
    include JSON::Serializable
    include JSON::Serializable::Unmapped
  end
end

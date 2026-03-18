struct Niki::ToolCall
  include Resource

  getter custom : Tool::Function?
  getter function : Tool::Function?
  getter id : String?
  getter type : Tool::Type
end

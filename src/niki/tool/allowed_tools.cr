struct Niki::Tool::AllowedTools
  include Resource

  getter read_only : Bool?
  getter tool_names : Array(String)?
end

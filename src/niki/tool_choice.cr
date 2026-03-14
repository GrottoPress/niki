struct Niki::ToolChoice
  enum Mode
    None
    Auto
    Required
  end

  include Resource

  getter mode : Mode?
  getter name : String?
  getter server_label : String?
  getter tools : Array(Tool)?
  getter type : Tool::Type
end

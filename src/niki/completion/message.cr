struct Niki::Completion::Message
  include Resource

  getter annotations : Array(Annotation)?
  getter audio : Audio?
  getter content : String?
  getter content_parts : Array(ContentPart)?
  getter id : String?
  getter refusal : String?
  getter role : Role
  getter tool_calls : Array(ToolCall)?
end

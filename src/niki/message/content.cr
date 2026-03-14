struct Niki::Message::Content
  enum Detail
    Low
    High
    Auto
  end

  enum Type
    InputText
    InputImage
    InputFile
    OutputText
    Refusal
    ReasoningText
  end

  include Resource

  getter annotations : Array(Annotation)?
  getter detail : Detail?
  getter file_data : String?
  getter file_id : String?
  getter file_url : String?
  getter filename : String?
  getter image_url : String?
  getter logprobs : Array(LogProb)?
  getter refusal : String?
  getter text : String?
  getter type : Type
end

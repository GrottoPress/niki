struct Niki::Completion::Choice
  enum FinishReason
    Stop
    Length
    ToolCalls
    ContentFilter
    FunctionCall
  end

  include Resource

  getter finish_reason : FinishReason?
  getter index : Int32?
  getter logprobs : LogProbs?
  getter message : Message?
end

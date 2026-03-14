struct Niki::Message::Output
  enum Type
    Message
    FileSearchCall
    ComputerCall
    ComputerCallOutput
    WebSearchCall
    FunctionCall
    FunctionCallOutput
    Reasoning
    Compaction
  end

  include Resource

  @action : ComputerAction | SearchAction | Nil
  @arguments : String | Hash(String, JSON::Any) | Nil

  getter content : Array(Content)?
  getter id : String?
  getter call_id : String?
  getter name : String?
  getter namespace : String?
  getter pending_safety_checks : Array(SafetyCheck)?
  getter phase : Phase?
  getter queries : Array(String)?
  getter results : Array(Result)?
  getter role : Role?
  getter status : Status?
  getter type : Type

  def arguments : Hash(String, JSON::Any)?
    @arguments.try do |arguments|
      next arguments if arguments.is_a?(Hash)
      @arguments = JSON.parse(arguments).as_h
    end
  end

  def computer_action : ComputerAction?
    @action.try &.as?(ComputerAction)
  end

  def search_action : SearchAction?
    @action.try &.as?(SearchAction)
  end
end

class Niki::Message
  enum Phase
    Commentary
    FinalAnswer
  end

  enum Role
    User
    Assistant
    System
    Developer
  end

  enum Status
    InProgress
    Completed
    Incomplete

    Searching
    Failed

    Cancelled
    Queued
  end

  enum Truncation
    Auto
    Disabled
  end

  include Resource

  @instructions : String | Array(Output) | Nil
  @tool_choice : ToolChoice::Mode | ToolChoice | Nil

  getter? background : Bool?
  getter conversation : Conversation?
  getter? deleted : Bool?
  getter id : String?
  getter incomplete_details : IncompleteDetails?
  getter max_output_tokens : Int32?
  getter max_tool_calls : Int32?
  getter metadata : Hash(String, String)?
  getter model : String?
  getter output : Array(Output)?
  getter? parallel_tool_calls : Bool?
  getter previous_response_id : String?
  getter prompt : Prompt?
  getter prompt_cache_key : String?
  getter prompt_cache_retention : String?
  getter reasoning : Reasoning?
  getter service_tier : ServiceTier?
  getter status : Status?
  getter temperature : Float64?
  getter text : Text?
  getter tools : Array(Tool)?
  getter top_logprobs : Int32?
  getter truncation : Truncation?
  getter top_p : Float64?
  getter usage : Usage?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter completed_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  def instructions : Array(Output)?
    @instructions.try do |instructions|
      next instructions if instructions.is_a?(Array)

      @instructions = [{
        content: [{type: :output_text, text: instructions}],
        type: :message
      }.to_json]
    end
  end

  def tool_choice : ToolChoice?
    @tool_choice.try do |tool_choice|
      next tool_choice if tool_choice.is_a?(ToolChoice)

      @tool_choice = ToolChoice.from_json({
        mode: tool_choice,
        type: :allowed_tools
      }.to_json)
    end
  end
end

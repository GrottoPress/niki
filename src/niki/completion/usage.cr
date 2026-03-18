struct Niki::Completion::Usage
  include Resource

  getter completion_tokens : Int32?
  getter prompt_tokens : Int32?
  getter total_tokens : Int32?
end

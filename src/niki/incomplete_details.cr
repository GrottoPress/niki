struct Niki::IncompleteDetails
  enum Reason
    MaxOutputTokens
    ContentFilter
  end

  include Resource

  getter reason : Reason
end

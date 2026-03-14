struct Niki::Tool::FileSearchFilters
  enum Type
    And
    Or
  end

  include Resource

  getter filters : Array(FileSearchFilter)
  getter type : Type
end

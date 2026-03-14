struct Niki::Tool::RequireApproval
  include Resource

  getter always : AllowedTools?
  getter never : AllowedTools?
end

module Niki::Pagination
  macro included
    getter first_id : String?
    getter? has_more : Bool?
    getter last_id : String?
  end
end

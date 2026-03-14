struct Niki::Tool::RankingOptions
  include Resource

  AUTO = "auto"
  DEFAULT_2024_11_15 = "default-2024-11-15"

  getter hybrid_search : HybridSearch?
  getter ranker : String?
  getter score_threshold : Int32?
end

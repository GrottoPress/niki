struct Niki::Embedding::List
  include Response

  getter data : Array(Embedding)?
  getter model : String?
  getter usage : Usage?
end

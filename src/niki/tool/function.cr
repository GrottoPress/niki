struct Niki::Tool::Function
  include Resource

  @arguments : String | Hash(String, JSON::Any) | Nil

  getter input : String?
  getter name : String

  def arguments : Hash(String, JSON::Any)?
    @arguments.try do |arguments|
      next arguments if arguments.is_a?(Hash)
      @arguments = JSON.parse(arguments).as_h
    end
  end
end

struct Niki::Tool::ShellEnvironment
  enum Type
    ContainerAuto
    Local
    ContainerReference
  end

  include Resource

  getter container_id : String?
  getter file_ids : Array(String)?
  getter memory_limit : String?
  getter network_policy : Container::NetworkPolicy?
  getter skills : Array(Skill)?
  getter type : Type
end

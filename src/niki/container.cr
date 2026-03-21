struct Niki::Container
  enum Type
    Auto
    ContainerAuto
    Local
    ContainerReference
  end

  include Resource

  @container_id : String?
  @id : String?

  getter? deleted : Bool?
  getter name : String?
  getter status : String?
  getter expires_after : ExpiresAfter?
  getter file_ids : Array(String)?
  getter memory_limit : String?
  getter network_policy : NetworkPolicy?
  getter skills : Array(Skill)?
  getter type : Type?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter created_at : Time?

  @[JSON::Field(converter: Time::EpochConverter)]
  getter last_active_at : Time?

  def id : String?
    @id || @container_id
  end
end

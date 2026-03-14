struct Niki::Container::NetworkPolicy
  enum Type
    Disabled
    Allowlist
  end

  include Resource

  getter allowed_domains : Array(String)?
  getter domain_secrets : Array(DomainSecret)?
  getter type : Type
end

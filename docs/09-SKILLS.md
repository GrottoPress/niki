## Skills

A skill is represented as `Niki::Skill`.

See <https://developers.openai.com/api/reference/resources/skills> for the raw JSON schema.

### Usage Examples

1. Upload a skill:

   ```crystal
   response = client.skills.upload("/path/to/skill.zip")

   response.data.try do |skill|
     puts skill.id
     puts skill.name
     puts skill.description
     puts skill.default_version
     puts skill.latest_version
   end
   ```

1. List skills:

   ```crystal
   response = client.skills.list(limit: "20", order: "desc")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
     end
   else
     response.data.try &.each do |skill|
       puts skill.id
       puts skill.name
       puts skill.description
     end

     response.first_id
     response.has_more?
     response.last_id
   end
   ```

1. Retrieve a skill:

   ```crystal
   response = client.skills.fetch("skill_abc123")

   response.data.try do |skill|
     puts skill.id
     puts skill.name
     puts skill.description
     puts skill.default_version
     puts skill.latest_version
     puts skill.created_at
   end
   ```

1. Delete a skill:

   ```crystal
   response = client.skills.delete("skill_abc123")

   response.data.try do |skill|
     puts skill.id
     puts skill.deleted?
   end
   ```

1. Update a skill:

   ```crystal
   response = client.skills.update("skill_abc123", default_version: "v2")

   response.data.try do |skill|
     puts skill.id
     puts skill.default_version
   end
   ```

1. Download skill:

   ```crystal
   client.skills.download(
     "skill_abc123",
     destination: "/home/user/Downloads/skill_abc123.zip" # May be an `IO`
   )
   ```

1. List skill versions:

   ```crystal
   response = client.skills.versions.list("skill_abc123")

   response.data.try &.each do |version|
     puts version.id
     puts version.skill_id
     puts version.version
     puts version.name
     puts version.description
     puts version.created_at
   end
   ```

1. Upload a skill version:

   ```crystal
   response = client.skills.versions.upload(
     "skill_abc123",
     "/path/to/skill-v2.zip"
   )

   response.data.try do |version|
     puts version.id
     puts version.skill_id
     puts version.version
     puts version.name
   end
   ```

1. Retrieve a skill version:

   ```crystal
   response = client.skills.versions.fetch("skill_abc123", "v1")

   response.data.try do |version|
     puts version.id
     puts version.skill_id
     puts version.version
     puts version.name
     puts version.description
     puts version.created_at
   end
   ```

1. Delete a skill version:

   ```crystal
   response = client.skills.versions.delete("skill_abc123", "v1")

   response.data.try do |version|
     puts version.id
     puts version.deleted?
   end
   ```

1. Download skill version:

   ```crystal
   client.skills.versions.download(
     "skill_abc123",
     "v1",
     destination: "/home/user/Downloads/skill_abc123.zip" # May be an `IO`
   )
   ```

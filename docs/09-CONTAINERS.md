## Containers

A container is represented as `Niki::Container`.

See <https://developers.openai.com/api/reference/resources/containers> for the raw JSON schema.

### Usage Examples

1. List containers:

   ```crystal
   response = client.containers.list

   response.data.try &.each do |container|
     puts container.id
     puts container.name
     puts container.status
     puts container.created_at
     puts container.last_active_at
     # ...
   end
   ```

1. Create a container:

   ```crystal
   response = client.containers.create(name: "my-container")

   response.data.try do |container|
     puts container.id
     puts container.name
     puts container.status
     # ...
   end
   ```

1. Retrieve a container:

   ```crystal
   response = client.containers.fetch("cntr_abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |container|
       puts container.id
       puts container.name
       puts container.status
       puts container.memory_limit
       puts container.expires_after
       puts container.network_policy
       # ...
     end
   end
   ```

1. Delete a container:

   ```crystal
   response = client.containers.delete("cntr_abc123")

   response.data.try do |container|
     puts container.id
     puts container.deleted?
   end
   ```

1. List container files:

   ```crystal
   response = client.containers.files.list("cntr_abc123")

   response.data.try &.each do |file|
     puts file.id
     puts file.bytes
     puts file.container_id
     puts file.created_at
     puts file.path
     puts file.source
     # ...
   end
   ```

1. Upload file to container:

   ```crystal
   response = client.containers.files.upload("cntr_abc123", "/path/to/file.txt")

   response.data.try do |file|
     puts file.id
     puts file.path
     puts file.bytes
     # ...
   end
   ```

1. Create file in container:

   ```crystal
   response = client.containers.files.create("cntr_abc123", file_id: "file.txt")

   response.data.try do |file|
     puts file.id
     puts file.path
     puts file.bytes
     # ...
   end
   ```

1. Retrieve a container file:

   ```crystal
   response = client.containers.files.fetch("cntr_abc123", "cfile_xyz789")

   response.data.try do |file|
     puts file.id
     puts file.path
     puts file.bytes
     # ...
   end
   ```

1. Delete a container file:

   ```crystal
   response = client.containers.files.delete("cntr_abc123", "cfile_xyz789")

   response.data.try do |file|
     puts file.id
     puts file.deleted?
   end
   ```

1. Download container file content:

   ```crystal
   destination = IO::Memory.new

   response = client.containers.files.content(
     "cntr_abc123",
     "cfile_xyz789",
     destination
   )

   puts destination.gets_to_end
   ```

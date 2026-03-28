## Files

A file is represented as `Niki::File`.

See <https://developers.openai.com/api/reference/resources/files> for the raw JSON schema.

### Usage Examples

1. Retrieve a file:

   ```crystal
   response = client.files.fetch("file-abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |file|
       puts file.id
       puts file.bytes
       puts file.created_at
       puts file.filename
       # ...
     end
   end
   ```

1. List files:

   ```crystal
   response = client.files.list

   response.data.try &.each do |file|
     puts file.id
     puts file.bytes
     puts file.created_at
     puts file.filename
     puts file.purpose
     # ...
   end
   ```

1. Upload a file:

   ```crystal
   response = client.files.upload("/path/to/file.jsonl", purpose: "batch")

   response.data.try do |file|
     puts file.id
     puts file.filename
     # ...
   end
   ```

1. Delete a file:

   ```crystal
   response = client.files.delete("file-abc123")

   response.data.try do |file|
     puts file.id
     puts file.deleted?
   end
   ```

1. Download file:

   ```crystal
   response = client.files.download(
     "file-abc123",
     destination: "/home/user/Downloads/backup.zip" # May be an `IO`
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   end
   ```

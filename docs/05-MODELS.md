## Models

A model is represented as `Niki::Model`.

See <https://platform.openai.com/docs/api-reference/models> for the raw JSON schema.

### Usage Examples

1. List models:

   ```crystal
   response = client.models.list

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try &.each do |model|
       puts model.id
       puts model.created
       puts model.owned_by
       # ...
     end
   end
   ```

1. Retrieve a model:

   ```crystal
   response = client.models.fetch("gpt-4o-2024-08-06")

   response.data.try do |model|
     puts model.id
     puts model.created
     puts model.owned_by
     # ...
   end
   ```

1. Delete a model:

   ```crystal
   response = client.models.delete("gpt-4o-2024-08-06")

   response.data.try do |model|
     puts model.id
     puts model.deleted?
   end
   ```

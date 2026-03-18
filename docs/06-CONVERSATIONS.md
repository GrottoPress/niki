## Conversations

A conversation is represented as `Niki::Conversation`.

See <https://developers.openai.com/api/reference/resources/conversations> for the raw JSON schema.

### Usage Examples

1. Create a conversation:

   ```crystal
   response = client.conversations.create

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |conversation|
       puts conversation.id
       puts conversation.created_at
       # ...
     end
   end
   ```

1. Retrieve a conversation:

   ```crystal
   response = client.conversations.fetch("conv_abc123")

   response.data.try do |conversation|
     puts conversation.id
     puts conversation.created_at
     puts conversation.metadata
     # ...
   end
   ```

1. Update a conversation:

   ```crystal
   response = client.conversations.update("conv_abc123")

   response.data.try do |conversation|
     puts conversation.id
     # ...
   end
   ```

1. Delete a conversation:

   ```crystal
   response = client.conversations.delete("conv_abc123")

   response.data.try do |conversation|
     puts conversation.id
     puts conversation.deleted?
   end
   ```

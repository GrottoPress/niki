## Chat Completions

A chat completion is represented as `Niki::Completion`.

See <https://developers.openai.com/api/reference/chat-completions/overview> for the raw JSON schema.

### Usage Examples

1. Create a completion:

   ```crystal
   response = client.completions.create(
     model: Niki::Model::GPT_5_4,
     messages: [
       {
         role: Niki::Role::Developer,
         content: "You are a helpful assistant."
       },
       {
         role: Niki::Role::User,
         content: "Hello!"
       }
     ]
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.completion
       # ...
     end
   else
     response.data.try do |completion|
       puts completion.id
       puts completion.model

       completion.choices.try &.each do |choice|
         puts choice.finish_reason
         puts choice.index

         choice.message.try do |message|
           puts message.content
           puts message.refusal
           puts message.role
           # ...
         end

         # ...
       end
     end

      # ...
    end
    ```

1. Retrieve a completion:

   ```crystal
   response = client.completions.fetch("chatcmpl-abc123")

   response.data.try do |completion|
     puts completion.service_tier
     puts completion.model
     # ...

     completion.usage.try do |usage|
       puts usage.completion_tokens
       puts usage.prompt_tokens
       puts usage.total_tokens
     end
   end
   ```

1. List completions:

   ```crystal
   response = client.completions.list(limit: "10")

   response.data.try &.each do |completion|
     puts completion.id
     # ...
   end
   ```

1. Update a completion:

   ```crystal
    response = client.completions.update("chatcmpl-abc123")

   response.data.try do |completion|
     puts completion.id
     # ...
   end
   ```

1. Delete a completion:

   ```crystal
   response = client.completions.delete("chatcmpl-abc123")

   response.data.try do |completion|
     puts completion.deleted?
   end
   ```

1. List completion messages:

   ```crystal
   response = client.completions.messages.list("chatcmpl-abc123")

   response.data.try &.each do |message|
     puts message.id
     puts message.content
     puts message.role
     # ...
   end
   ```

## Messages

A message is represented as `Niki::Message`. This uses OpenAI's *Responses API*.

See <https://developers.openai.com/api/reference/responses/overview> for the raw JSON schema.

### Usage Examples

1. Create a message:

   ```crystal
   response = client.messages.create(
     model: "gpt-5.4",
     input: "Tell me a three sentence bedtime story about a unicorn."
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |message|
       puts message.id
       puts message.model

       message.output.try &.each do |output|
         puts output.type
         puts output.status
         puts output.role

         output.content.try &.each do |content|
           puts content.type
           puts content.text
           # ...
         end

         # ...
       end
     end

     # ...
   end
   ```

1. Retrieve a message:

   ```crystal
   response = client.messages.fetch("resp_123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |message|
       puts message.created_at.try(&.day)
       puts message.completed_at.try(&.month)
       puts message.incomplete_details.try(&.reason)

       message.output.try &.each do |output|
         puts output.id
         puts output.status

         output.content.try &.each do |content|
           puts content.type
           puts content.text
           # ...
         end

         # ...
       end
     end
   end
   ```

1. Delete a message:

   ```crystal
   response = client.messages.delete("resp_123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     puts response.object

     response.data.try do |message|
       puts message.id
       puts message.deleted?
       # ...
     end
   end
   ```

1. Count input tokens:

   ```crystal
   response = client.messages.input_tokens(
     model: "gpt-5",
     input: "Tell me a joke."
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     puts response.object

     response.data.try do |usage|
       puts usage.input_tokens

       puts usage.input_token_details.try do |details|
         puts details.cached_tokens
         puts details.reasoning_tokens
         # ...
       end

       # ...
     end
   end
   ```

1. Cancel a message:

   ```crystal
   response = client.messages.cancel("resp_123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |message|
       puts message.status
       puts message.background?
       puts message.parallel_tool_calls?
       # ...
     end
   end
   ```

1. Compact a message:

   ```crystal
   response = client.messages.compact(
     model: "gpt-5.1-codex-max",
     input: [
       {
         role: Niki::Role::User,
         content: "Create a simple landing page for a dog petting café."
       },
       {
         id: "msg_001",
         type: Niki::Message::Output::Type::Message,
         status: "completed",
         content: [
           {
             type: Niki::Message::Content::Type::OutputText,
             annotations: [],
             logprobs: [],
             text: "Below is a single file, ready-to-use landing page for a dog petting café:..."
           }
         ],
         role: Niki::Role::::Assistant
       }
     ]
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |message|
       puts message.id
       puts message.created_at.try(&.day_of_week)
       # ...

       message.usage.try do |usage|
         puts usage.input_tokens
         puts usage.output_tokens
       end
     end
   end
   ```

1. List input items:

   ```crystal
   response = client.messages.input_items.list("resp_abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try &.each do |output|
       puts output.id
       puts output.type
       puts output.role
       # ...
     end
   end
   ```

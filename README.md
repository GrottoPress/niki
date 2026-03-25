# Niki

*Niki* is a low-level API client for *OpenAI*. It features an intuitive interface that maps directly to the *OpenAI* API.

### Usage Examples

```crystal
# Create a new client
client = Niki.new(api_key: "openai-api-key")
```

1. Create a message (Uses the *Responses API*):

   ```crystal
   response = client.messages.create(
     model: Niki::Model::GPT_5_4,
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

1. Create a chat completion:

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

1. List models:

   ```crystal
   response = client.models.list(limit: 10)

   if response.error
     response.error.try do |error|
       puts error.type
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

## Documentation

Find the complete documentation in the `docs/` directory of this repository.

## Development

Generate an API key from your OpenAI [account](https://platform.openai.com).

Create a `.env.sh` file:

```bash
#!/usr/bin/env bash
#
export OPENAI_API_KEY='your-openai-api-key-here'
```

Update the file with your own details. Then run tests with `source .env.sh && crystal spec`.

**IMPORTANT**: Remember to set permissions for your env file to `0600` or stricter: `chmod 0600 .env*`.

## Contributing

1. [Fork it](https://github.com/GrottoPress/niki/fork)
1. Switch to the `master` branch: `git checkout master`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Make your changes, updating changelog and documentation as appropriate.
1. Commit your changes: `git commit`
1. Push to the branch: `git push origin my-new-feature`
1. Submit a new *Pull Request* against the `GrottoPress:master` branch.

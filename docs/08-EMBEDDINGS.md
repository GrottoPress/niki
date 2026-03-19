## Embeddings

An embedding is represented as `Niki::Embedding`.

See <https://platform.openai.com/docs/api-reference/embeddings> for the raw JSON schema.

### Usage Examples

1. Create embedding from a string:

   ```crystal
   response = client.embeddings.create(
     input: "The quick brown fox",
     model: "text-embedding-3-small",
     encoding_format: "float"
   )

   response.data.try &.first?.try do |embedding|
     embedding.vector.try &.each do |value|
       puts value
     end
   end

   response.usage.try do |usage|
     puts usage.prompt_tokens
     puts usage.total_tokens
   end
   ```

1. Create embeddings from an array of strings:

   ```crystal
   response = client.embeddings.create(
     input: ["The quick brown fox", "jumped over the lazy dog"],
     model: "text-embedding-3-small",
     encoding_format: "base64",
     dimensions: 256
   )

   response.data.try &.each_with_index do |embedding, index|
     puts "Embedding #{index}: #{embedding.vector}"
   end
   ```

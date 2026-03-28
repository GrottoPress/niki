## Videos

The videos API allows you to generate, list, retrieve, and delete videos using OpenAI's video generation models (Sora).

Video resources are represented as `Niki::Video`.

See <https://developers.openai.com/api/reference/resources/videos> for the raw JSON schemas.

### Usage Examples

1. Generate a video:

   ```crystal
   response = client.videos.create(
     prompt: "A cool cat on a motorcycle in the night",
     model: Niki::Model::SORA_2,
     size: Niki::Video::SIZE_1280_720,
     seconds: "8"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.id
       puts video.status
       puts video.model
       puts video.prompt
       puts video.size
       puts video.seconds
       puts video.progress
       # ...
     end
   end
   ```

1. List videos:

   ```crystal
   response = client.videos.list(limit: 20, order: "desc")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try &.each do |video|
       puts video.id
       puts video.status
       puts video.model
       puts video.created_at
       # ...
     end
   end
   ```

1. Fetch a video:

   ```crystal
   response = client.videos.fetch("video_abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.id
       puts video.status
       puts video.progress
       puts video.completed_at
       # ...
     end
   end
   ```

1. Delete a video:

   ```crystal
   response = client.videos.delete("video_abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.deleted?
       # ...
     end
   end
   ```

1. Download a video:

   ```crystal
   response = client.videos.download(
     "video_abc123",
     destination: "/home/user/Downloads/video_abc123.mp4" # May be an `IO`
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   end
   ```

1. Extend a video:

   ```crystal
   response = client.videos.extend(
     "video_abc123",
     prompt: "Continue the scene with the cat taking a bow",
     seconds: "8"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.id
       puts video.status
       puts video.seconds
       # ...
     end
   end
   ```

1. Edit a video:

   ```crystal
   response = client.videos.edit(
     "video_abc123",
     prompt: "Make it sunset with orange skies"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.id
       puts video.status
       # ...
     end
   end
   ```

1. Remix a video:

   ```crystal
   response = client.videos.remix(
     "video_abc123",
     prompt: "Remix with a cyberpunk aesthetic"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |video|
       puts video.id
       puts video.status
       # ...
     end
   end
   ```

## Characters

Characters let you upload a reusable non-human subject (animal, mascot, object) and reference it across multiple generations for stronger visual consistency.

Character resources are represented as `Niki::Video::Character`.

### Usage Examples

1. Create a character from video:

   ```crystal
   response = client.videos.characters.create("/path/to/video.mp4", name: "Mossy")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |character|
       puts character.id
       puts character.name
       puts character.created_at
       # ...
     end
   end
   ```

1. Fetch a character

   ```crystal
   response = client.videos.characters.fetch("char_abc123")

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |character|
       puts character.id
       puts character.name
       puts character.created_at
       # ...
     end
   end
   ```

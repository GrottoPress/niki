## Audio

The audio API provides speech generation, transcription, translation, and voice cloning capabilities.

Speech generation is represented as `Niki::Audio::Speech`, transcription as `Niki::Audio::Transcription`, translation as `Niki::Audio::Translation`, and voice as `Niki::Audio::Voice`.

See <https://developers.openai.com/api/reference/resources/audio> for the raw JSON schemas.

### Usage Examples

1. Generate speech:

   ```crystal
   destination = IO::Memory.new

   response = client.audios.speeches.create(
     destination,
     model: "gpt-4o-mini-tts",
     input: "The quick brown fox jumped over the lazy dog.",
     voice: "alloy"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     File.write("/path/to/audio.mp3", destination)
   end
   ```

1. Create a transcription:

   ```crystal
   response = client.audios.transcriptions.create(
     "/path/to/audio.mp3",
     model: "gpt-4o-transcribe"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |transcription|
       puts transcription.text
       puts transcription.language
       puts transcription.duration
       # ...
     end
   end
   ```

1. Create a translation:

   ```crystal
   response = client.audios.translations.create(
     "/path/to/audio.mp3",
     model: "whisper-1"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |translation|
       puts translation.text
       puts translation.language
       puts translation.duration
       # ...
     end
   end
   ```

1. Create a voice:

   ```crystal
   response = client.audios.voices.create(
     "/path/to/sample.mp3",
     name: "My Voice"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |voice|
       puts voice.id
       puts voice.name
       puts voice.created_at
       # ...
     end
   end
   ```

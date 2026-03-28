## Audio

The audio API provides speech generation, transcription, translation, voice cloning, and voice consent capabilities.

Speech generation is represented as `Niki::Audio::Speech`, transcription as `Niki::Audio::Transcription`, translation as `Niki::Audio::Translation`, voice as `Niki::Audio::Voice`, and consent as `Niki::Audio::Consent`.

See <https://developers.openai.com/api/reference/resources/audio> for the raw JSON schemas.

### Usage Examples

1. Generate speech:

   ```crystal
   response = client.audios.speeches.create(
     destination: "/home/user/Downloads/audio.mp3" # May be an `IO`
     model: Niki::Model::GPT_4O_MINI_TTS,
     input: "The quick brown fox jumped over the lazy dog.",
     voice: "alloy"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   end
   ```

1. Create a transcription:

   ```crystal
   response = client.audios.transcriptions.create(
     "/path/to/audio.mp3",
     model: Niki::Model::GPT_4O_TRANSCRIBE
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
     model: Niki::Model::WHISPER_1
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

1. Upload a voice consent:

   ```crystal
   response = client.audios.consents.create(
     "/path/to/recording.wav",
     name: "John Doe",
     language: "en"
   )

   if response.error
     response.error.try do |error|
       puts error.code
       puts error.message
       # ...
     end
   else
     response.data.try do |consent|
       puts consent.id
       puts consent.name
       puts consent.language
       puts consent.created_at
       # ...
     end
   end
   ```

1. List voice consents:

   ```crystal
   response = client.audios.consents.list

   response.data.try &.each do |consent|
     puts consent.id
     puts consent.name
     puts consent.language
     # ...
   end
   ```

1. Fetch a voice consent:

   ```crystal
   response = client.audios.consents.fetch("cons_abc123")

   response.data.try do |consent|
     puts consent.id
     puts consent.name
     # ...
   end
   ```

1. Update a voice consent:

   ```crystal
   response = client.audios.consents.update("cons_abc123", name: "Jane Doe")

   response.data.try do |consent|
     puts consent.name
     # ...
   end
   ```

1. Delete a voice consent:

   ```crystal
   response = client.audios.consents.delete("cons_abc123")

   response.data.try do |consent|
     puts consent.deleted?
     # ...
   end
   ```

struct Niki::Error
  enum Code
    InvalidPrompt = 400
    RateLimitExceeded = 429
    ServerError = 500

    VectorStoreTimeout
    InvalidImage
    InvalidImageFormat
    InvalidBase64Image
    InvalidImageUrl
    ImageTooLarge
    ImageTooSmall
    ImageParseError
    ImageContentPolicyViolation
    InvalidImageMode
    ImageFileTooLarge
    UnsupportedImageMediaType
    EmptyImageFile
    FailedToDownloadImage
    ImageFileNotFound
  end

  include Resource

  getter code : Code
  getter message : String
end

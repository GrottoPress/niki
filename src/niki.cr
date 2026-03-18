require "http/client"
require "json"

require "./niki/version"
require "./niki/endpoint"
require "./niki/resource"
require "./niki/**"

struct Niki
  getter :uri

  def initialize(api_key : String, @uri : URI)
    @http_client = HTTP::Client.new(uri)
    set_headers(api_key)
  end

  def self.new(api_key : String, uri = "https://api.openai.com/v1") : self
    new api_key, URI.parse(uri)
  end

  forward_missing_to @http_client

  def completions : Completion::Endpoint
    Completion::Endpoint.new(self)
  end

  def messages : Message::Endpoint
    Message::Endpoint.new(self)
  end

  def models : Model::Endpoint
    Model::Endpoint.new(self)
  end

  private def set_headers(api_key)
    @http_client.before_request do |request|
      set_api_key(request.headers, api_key)
      set_content_type(request.headers)
      set_user_agent(request.headers)
    end
  end

  private def set_api_key(headers, api_key)
    headers["Authorization"] = "Bearer #{api_key}"
  end

  private def set_content_type(headers)
    headers["Content-Type"] = "application/json"
  end

  private def set_user_agent(headers)
    headers["User-Agent"] = "Niki/#{Niki::VERSION} \
      (+https://github.com/GrottoPress/niki)"
  end
end

class Niki::Tool
  enum Action
    Generate
    Edit
    Auto
  end

  enum Approval
    Always
    Never
  end

  enum Background
    Transparent
    Opaque
    Auto
  end

  enum ConnectorId
    ConnectorDropbox
    ConnectorGmail
    ConnectorGooglecalendar
    ConnectorGoogledrive
    ConnectorMicrosoftteams
    ConnectorOutlookcalendar
    ConnectorOutlookemail
    ConnectorSharepoint
  end

  enum ContentType
    Text
    Image
  end

  enum ContextSize
    Low
    Medium
    High
  end

  enum Environment
    Windows
    Mac
    Linux
    Ubuntu
    Browser
  end

  enum Execution
    Server
    Client
  end

  enum Fidelity
    High
    Low
  end

  enum ImageModeration
    Auto
    Low
  end

  enum OutputFormat
    Png
    Webp
    Jpeg
  end

  enum Quality
    Low
    Medium
    High
    Auto
  end

  enum Type
    AllowedTools
    FileSearch
    WebSearch
    WebSearch_2025_08_26
    WebSearchPreview
    Computer
    ComputerUsePreview
    ComputerUse
    WebSearchPreview_2025_03_11
    ImageGeneration
    CodeInterpreter
    Function
    Mcp
    Custom
    ApplyPatch
    Shell
    LocalShell
    Namespace
    ToolSearch
  end

  include Resource

  @allowed_tools : Array(String) | AllowedTools | Nil
  @container : String | Container | Nil
  @environment : Environment | Container | Nil
  @filters : FileSearchFilter | FileSearchFilters | WebSearchFilters | Nil
  @require_approval : Approval | RequireApproval | Nil
  @tools : self | Array(self) | Nil

  getter action : Action?
  getter authorization : String?
  getter background : Background?
  getter connector_id : ConnectorId?
  getter? defer_loading : Bool?
  getter description : String?
  getter display_height : Int32?
  getter display_width : Int32?
  getter execution : Execution?
  getter format : Format?
  getter headers : Hash(String, String)?
  getter input_fidelity : Fidelity?
  getter input_image_mask : ImageMask?
  getter max_num_results : Int32?
  getter model : String?
  getter moderation : ImageModeration?
  getter name : String?
  getter output_compression : Int32?
  getter output_format : OutputFormat?
  getter parameters : Hash(String, JSON::Any)?
  getter partial_images : Int32?
  getter quality : Quality?
  getter ranking_options : RankingOptions?
  getter search_content_type : Array(ContentType)?
  getter search_context_size : ContextSize?
  getter server_description : String?
  getter server_label : String?
  getter server_url : String?
  getter size : String?
  getter? strict : Bool?
  getter type : Type
  getter user_location : Location?
  getter vector_store_ids : Array(String)?

  def allowed_tools : AllowedTools?
    @allowed_tools.try do |tools|
      next tools if tools.is_a?(AllowedTools)
      @allowed_tools = AllowedTools.from_json({tool_names: tools}.to_json)
    end
  end

  def container : Container?
    @container.try do |container|
      next container if container.is_a?(Container)

      @container = Container.from_json({
        container_id: container,
        type: :auto
      }.to_json)
    end
  end

  def environment : Environment?
    @environment.try &.as?(Environment)
  end

  def file_search_filters : FileSearchFilters?
    @filters.try do |filters|
      next filters if filters.is_a?(FileSearchFilters)
      next unless filters.is_a?(FileSearchFilter)

      @filters = FileSearchFilters.from_json({
        filters: {filters},
        type: :and
      }.to_json)
    end
  end

  def require_approval : RequireApproval?
    @require_approval.try do |approval|
      next approval if approval.is_a?(RequireApproval)

      json = approval.always? ?
        {always: NamedTuple.new} :
        {never: NamedTuple.new}

      @require_approval = RequireApproval.from_json({json.to_json})
    end
  end

  def shell_environment : Container?
    @environment.try &.as?(Container)
  end

  def tools : Array(self)?
    @tools.try do |tools|
      next tools if tools.is_a?(Array)
      @tools = [tools]
    end
  end

  def web_search_filters : WebSearchFilters?
    @filters.try &.as?(WebSearchFilters)
  end
end

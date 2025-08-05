module DeviceDetector
  class Response
    class NotEmplementedException < Exception; end

    alias InputStructure = Array(Hash(String, Hash(String, String)))

    def initialize(@results : InputStructure)
    end

    def raw
      @results
    end

    macro method_missing(m)
      method_name = {{m.name.stringify}}
      raise NotEmplementedException.new("Method #{method_name} not implemented yet.")
    end

    ENTITIES = {
      bot:                   ["name", "category", "url", "producer_name", "producer_url"],
      browser:               ["name", "version"],
      browser_engine:        ["name"],
      camera:                ["device", "vendor"],
      car_browser:           ["model", "vendor"],
      console:               ["model", "vendor"],
      feed_reader:           ["name", "version"],
      library:               ["name", "version"],
      mediaplayer:           ["name", "version"],
      mobile_app:            ["name", "version"],
      mobile:                ["vendor", "type", "model"],
      os:                    ["name", "version"],
      pim:                   ["name", "version"],
      portable_media_player: ["model", "vendor"],
      tv:                    ["model", "vendor"],
      vendorfragment:        ["vendor"],
    }

    # Custom Producer class for bot
    class Producer
      def initialize(@section : Hash(String, String))
      end

      def name? : Bool
        @section.has_key?("name") && !@section["name"].try &.blank?
      end

      def name : String?
        @section["name"]?
      end

      def url? : Bool
        @section.has_key?("url") && !@section["url"].try &.blank?
      end

      def url : String?
        @section["url"]?
      end
    end

    {% for entity_name, keys in ENTITIES %}
      {% class_name = entity_name.stringify.camelcase %}

      class {{class_name.id}}
        def initialize(@section : Hash(String, String))
        end

        {% for key, index in keys %}
          {% if key.is_a?(StringLiteral) %}
            def {{key.id}}? : Bool
              @section.has_key?({{key}}) && !@section[{{key}}].try &.blank?
            end

            def {{key.id}} : String?
              @section[{{key}}]?
            end
          {% end %}
        {% end %}

        # Custom producer method for Bot
        {% if entity_name == :bot %}
          def producer : Producer
            if @section.has_key?("producer_name") && !@section["producer_name"].blank?
              producer_data = {"name" => @section["producer_name"], "url" => @section["producer_url"]? || ""}
              Producer.new(producer_data)
            else
              Producer.new({} of String => String)
            end
          end
        {% end %}
      end

      def {{entity_name.id}}? : Bool
        @results.each do |result|
          if result.has_key?({{entity_name.stringify}})
            return !result.dig?({{entity_name.stringify}}, {{keys.first}}).try &.blank?
          end
        end

        false
      end

      def {{entity_name.id}} : {{class_name.id}}
        @results.each do |result|
          if result.has_key?({{entity_name.stringify}})
            return {{class_name.id}}.new(result[{{entity_name.stringify}}])
          end
        end

        {{class_name.id}}.new({} of String => String)
      end

      # Old API support (DEPRECATED)
      {% for key, index in keys %}
        {% if key.is_a?(StringLiteral) %}
          @[Deprecated("Use `{{entity_name.id}}.{{key.id}}` instead")]
          def {{entity_name.id}}_{{key.id}}
            {{entity_name.id}}.{{key.id}}
          end
        {% end %}
      {% end %}
    {% end %}

    # Custom bot producer method
    def bot_producer : Producer
      @results.each do |result|
        if result.has_key?("bot")
          bot_data = result["bot"]
          if bot_data.has_key?("producer_name") && !bot_data["producer_name"].blank?
            producer_data = {"name" => bot_data["producer_name"], "url" => bot_data["producer_url"]? || ""}
            return Producer.new(producer_data)
          end
        end
      end

      Producer.new({} of String => String)
    end

    # Old API support (DEPRECATED)
    @[Deprecated("Use `camera.device` instead")]
    def camera_model
      camera.device
    end

    @[Deprecated("Use `mobile?` instead")]
    def mobile_device?
      mobile?
    end

    @[Deprecated("Use `mobile` instead")]
    def mobile_device
      mobile
    end

    @[Deprecated("Use `mobile.vendor` instead")]
    def mobile_device_vendor
      mobile.vendor
    end

    @[Deprecated("Use `mobile.type` instead")]
    def mobile_device_type
      mobile.type
    end

    @[Deprecated("Use `mobile.model` instead")]
    def mobile_device_model
      mobile.model
    end

    # `to.click` related method
    def traffic_type
      if [library?, bot?].any?(true)
        "bot"
      else
        "human"
      end
    end
  end
end

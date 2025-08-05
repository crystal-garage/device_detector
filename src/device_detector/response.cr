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
      bot:                   ["name", "category", "url", {producer: ["name", "url"]}],
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

    {% for entity_name, keys in ENTITIES %}
      {% class_name = entity_name.stringify.camelcase %}

      class {{class_name.id}}
        def initialize(@section : Hash(String, String))
        end

        {% for key in keys %}
          {% if key.is_a?(NamedTupleLiteral) %}
            {% nested_class_name = key.keys.first.stringify.camelcase %}
            {% instance_method_name = key.keys.first.id %}

            class {{nested_class_name.id}}
              def initialize(@section : Hash(String, String))
              end

              {% for nested_key in key.values.first %}
                def {{nested_key.id}}? : Bool
                  @section.has_key?({{nested_key}}) && !@section[{{nested_key}}].try &.blank?
                end

                def {{nested_key.id}} : String?
                  @section["{{key.keys.first.id}}_{{nested_key.id}}"]?
                end
              {% end %}
            end

            def {{instance_method_name.id}} : {{nested_class_name.id}}
              {{nested_class_name.id}}.new(@section)
            end
          {% elsif key.is_a?(StringLiteral) %}
            def {{key.id}}? : Bool
              @section.has_key?({{key}}) && !@section[{{key}}].try &.blank?
            end

            def {{key.id}} : String?
              @section[{{key}}]?
            end
          {% end %}
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

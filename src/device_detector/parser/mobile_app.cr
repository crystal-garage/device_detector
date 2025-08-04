module DeviceDetector::Parser
  struct MobileApp
    include Helper

    getter kind = "mobile_app"
    @@apps : Array(MobileApp)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct MobileApp
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
    end

    def apps
      @@apps ||= Array(MobileApp).from_yaml(Storage.get("client/mobile_apps.yml"))
    end

    def call
      detected_app = {"name" => "", "version" => ""}
      apps.reverse_each do |app|
        if Regex.new(app.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_app.merge!({"name" => app.name})
          if version = app.version
            if capture_groups?(version)
              version = fill_groups(version, app.regex, @user_agent)
              detected_app.merge!({"version" => version})
            else
              detected_app.merge!({"version" => version})
            end
          end
        end
      end
      detected_app
    end
  end
end

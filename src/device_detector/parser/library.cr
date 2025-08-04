module DeviceDetector::Parser
  struct Library
    include Helper

    getter kind = "library"
    @@libraries : Array(Library)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct Library
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
    end

    def libraries
      @@libraries ||= Array(Library).from_yaml(Storage.get("client/libraries.yml"))
    end

    def call
      detected_library = {"name" => "", "version" => ""}
      libraries.reverse_each do |library|
        if Regex.new(library.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_library.merge!({"name" => library.name})
          if version = library.version
            if capture_groups?(version)
              version = fill_groups(version, library.regex, @user_agent)
              detected_library.merge!({"version" => version})
            else
              detected_library.merge!({"version" => version})
            end
          end
        end
      end
      detected_library
    end
  end
end

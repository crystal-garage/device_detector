module DeviceDetector::Parser
  struct OS
    include Helper

    getter kind = "os"
    @@os = Array(OS).from_yaml(Storage.get("oss.yml"))

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct OS
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String
    end

    def os
      return @@os if @@os
      @@os = Array(OS).from_yaml(Storage.get("oss.yml"))
    end

    def call
      detected_os = {"name" => "", "version" => ""}
      os.reverse_each do |operation_system|
        if Regex.new(operation_system.regex, Setting::REGEX_OPTS) =~ @user_agent
          # If name contains capture groups
          if capture_groups?(operation_system.name)
            name = fill_groups(operation_system.name, operation_system.regex, @user_agent)
            detected_os.merge!({"name" => name})
          else
            detected_os.merge!({"name" => operation_system.name})
          end
          # If version contains capture groups
          if capture_groups?(operation_system.version)
            version = fill_groups(operation_system.version, operation_system.regex, @user_agent)
            detected_os.merge!({"version" => version})
          else
            detected_os.merge!({"version" => operation_system.version})
          end
        end
      end
      detected_os
    end
  end
end

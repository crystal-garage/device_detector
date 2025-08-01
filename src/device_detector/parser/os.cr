module DeviceDetector::Parser
  struct OS
    include Helper

    getter kind = "os"
    @@os : Array(OS)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct VersionRule
      include YAML::Serializable

      property regex : String
      property version : String
    end

    struct OS
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
      property versions : Array(VersionRule)?
    end

    def os
      @@os ||= Array(OS).from_yaml(Storage.get("oss.yml"))
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

          # Handle version detection
          version = ""

          # Check if we have version rules
          if versions = operation_system.versions
            versions.reverse_each do |version_rule|
              if Regex.new(version_rule.regex, Setting::REGEX_OPTS) =~ @user_agent
                if capture_groups?(version_rule.version)
                  version = fill_groups(version_rule.version, version_rule.regex, @user_agent)
                else
                  version = version_rule.version
                end
                break
              end
            end
          elsif version_str = operation_system.version
            # Handle single version field
            if capture_groups?(version_str.not_nil!)
              version = fill_groups(version_str.not_nil!, operation_system.regex, @user_agent)
            else
              version = version_str.not_nil!
            end
          end

          detected_os.merge!({"version" => version})
        end
      end
      detected_os
    end
  end
end

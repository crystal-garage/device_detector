module DeviceDetector::Parser
  struct OS
    include Helper

    getter kind = "os"
    @@oss : Array(OS)?

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

    def oss
      @@oss ||= Array(OS).from_yaml(Storage.get("oss.yml"))
    end

    def call
      detected_os = {"name" => "", "version" => ""}
      oss.reverse_each do |os|
        if RegexCache.get(os.regex) =~ @user_agent
          # If name contains capture groups
          if capture_groups?(os.name)
            name = fill_groups(os.name, os.regex, @user_agent)
            detected_os.merge!({"name" => name})
          else
            detected_os.merge!({"name" => os.name})
          end

          # Handle version detection
          version = ""

          # Check if we have version rules
          if versions = os.versions
            versions.reverse_each do |version_rule|
              if RegexCache.get(version_rule.regex) =~ @user_agent
                if capture_groups?(version_rule.version)
                  version = fill_groups(version_rule.version, version_rule.regex, @user_agent)
                else
                  version = version_rule.version
                end
                break
              end
            end
          elsif version_str = os.version
            # Handle single version field
            if capture_groups?(version_str)
              version = fill_groups(version_str, os.regex, @user_agent)
            else
              version = version_str
            end
          end

          detected_os.merge!({"version" => version})
        end
      end
      detected_os
    end
  end
end

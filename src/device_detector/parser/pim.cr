module DeviceDetector::Parser
  struct PIM
    include Helper

    getter kind = "pim"
    @@pims : Array(PIM)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct PIM
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
    end

    def pims
      @@pims ||= Array(PIM).from_yaml(Storage.get("client/pim.yml"))
    end

    def call
      detected_pim = {"name" => "", "version" => ""}
      pims.reverse_each do |pim|
        if Regex.new(pim.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_pim.merge!({"name" => pim.name})
          if version = pim.version
            if capture_groups?(version)
              version = fill_groups(version, pim.regex, @user_agent)
              detected_pim.merge!({"version" => version})
            else
              detected_pim.merge!({"version" => version})
            end
          end
        end
      end
      detected_pim
    end
  end
end

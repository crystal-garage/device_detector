module DeviceDetector::Parser
  struct Mediaplayer
    include Helper

    getter kind = "mediaplayer"
    @@players : Array(Mediaplayer)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct Mediaplayer
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
    end

    def players
      @@players ||= Array(Mediaplayer).from_yaml(Storage.get("client/mediaplayers.yml"))
    end

    def call
      detected_player = {"name" => "", "version" => ""}
      players.reverse_each do |player|
        if Regex.new(player.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_player.merge!({"name" => player.name})
          if version = player.version
            if capture_groups?(version)
              version = fill_groups(version, player.regex, @user_agent)
              detected_player.merge!({"version" => version})
            else
              detected_player.merge!({"version" => version})
            end
          end
        end
      end
      detected_player
    end
  end
end

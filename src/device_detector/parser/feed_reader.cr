module DeviceDetector::Parser
  struct FeedReader
    include Helper

    getter kind = "feed_reader"
    @@readers : Array(Reader)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct Reader
      include YAML::Serializable

      property regex : String
      property name : String
      property version : String?
    end

    def readers
      @@readers ||= Array(Reader).from_yaml(Storage.get("client/feed_readers.yml"))
    end

    def call
      detected_reader = {"name" => "", "version" => ""}
      readers.reverse_each do |reader|
        if Regex.new(reader.regex, Setting::REGEX_OPTS) =~ @user_agent
          detected_reader.merge!({"name" => reader.name})
          if version = reader.version
            if capture_groups?(version)
              version = fill_groups(version, reader.regex, @user_agent)
              detected_reader.merge!({"version" => version})
            else
              detected_reader.merge!({"version" => version})
            end
          end
        end
      end
      detected_reader
    end
  end
end

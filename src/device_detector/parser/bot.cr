module DeviceDetector::Parser
  struct Bot
    getter kind = "bot"
    @@bots : Array(Bot)?

    def initialize(@user_agent : String)
    end

    struct Producer
      include YAML::Serializable

      property name : String
      property url : String?
    end

    struct Bot
      include YAML::Serializable

      property regex : String
      property name : String
      property category : String?
      property url : String?
      property producer : Producer?
    end

    def bots
      @@bots ||= Array(Bot).from_yaml(Storage.get("bots.yml"))
    end

    def call
      detected_bot = {"name" => "", "category" => "", "url" => "", "producer_name" => "", "producer_url" => ""}
      bots.reverse_each do |bot|
        if RegexCache.get(bot.regex) =~ @user_agent
          detected_bot["name"] = bot.name
          detected_bot["category"] = bot.category.to_s if bot.category
          detected_bot["url"] = bot.url.to_s if bot.url
          if producer = bot.producer
            detected_bot["producer_name"] = producer.name
            detected_bot["producer_url"] = producer.url.to_s if producer.url
          end
        end
      end
      detected_bot
    end
  end
end

module DeviceDetector::Parser
  struct Console
    include Helper

    getter kind = "console"
    @@consoles : Hash(String, ConsoleVendor)?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    struct ConsoleModel
      include YAML::Serializable

      property regex : String
      property model : String
    end

    struct ConsoleVendor
      include YAML::Serializable

      property regex : String
      property device : String
      property model : String?
      property models : Array(ConsoleModel)?
    end

    def consoles
      @@consoles ||= Hash(String, ConsoleVendor).from_yaml(Storage.get("device/consoles.yml"))
    end

    def call
      detected_console = {"vendor" => "", "model" => ""}
      consoles.each do |vendor_name, vendor_data|
        # Check if the main regex matches
        if RegexCache.get(vendor_data.regex) =~ @user_agent
          detected_console.merge!({"vendor" => vendor_name})

          # Handle version detection
          model = ""

          # Check if we have model rules
          if models = vendor_data.models
            models.reverse_each do |model_rule|
              if RegexCache.get(model_rule.regex) =~ @user_agent
                if capture_groups?(model_rule.model)
                  model = fill_groups(model_rule.model, model_rule.regex, @user_agent)
                else
                  model = model_rule.model
                end
                break
              end
            end
          elsif model_str = vendor_data.model
            # Handle single model field
            if capture_groups?(model_str)
              model = fill_groups(model_str, vendor_data.regex, @user_agent)
            else
              model = model_str
            end
          end

          detected_console.merge!({"model" => model})
          break
        end
      end
      detected_console
    end
  end
end

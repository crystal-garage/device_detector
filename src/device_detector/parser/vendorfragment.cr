module DeviceDetector::Parser
  struct VendorFragment
    include Helper

    getter kind = "vendorfragment"
    @@fragments : Hash(String, Array(String))?

    def initialize(user_agent : String)
      @user_agent = user_agent
    end

    def fragments
      @@fragments ||= Hash(String, Array(String)).from_yaml(Storage.get("vendorfragments.yml"))
    end

    def call
      detected_vendor = {"vendor" => ""}
      fragments.each do |fragment|
        vendor = fragment[0]
        regexes = fragment[1]
        regexes.each do |regex|
          if RegexCache.get(regex) =~ @user_agent
            detected_vendor.merge!({"vendor" => vendor})
          end
        end
      end
      detected_vendor
    end
  end
end

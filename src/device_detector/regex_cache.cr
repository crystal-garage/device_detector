module DeviceDetector
  module RegexCache
    @@cache = Hash(String, Regex).new

    def self.get(regex_str : String) : Regex
      @@cache[regex_str]? || (@@cache[regex_str] = Regex.new(regex_str, Setting::REGEX_OPTS))
    end

    def self.clear
      @@cache.clear
    end
  end
end

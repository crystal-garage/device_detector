require "./spec_helper"
require "../src/device_detector/parser"

describe "In the parsers" do
  describe "Bot" do
    it "should extract bot name" do
      user_agent = "Googlebot (gocrawl v0.4)"
      detector = DeviceDetector::Parser::Bot.new user_agent
      detector.call["name"].should eq "Googlebot"
    end
  end

  describe "BrowserEngine" do
    it "should extract engine name" do
      user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
      detector = DeviceDetector::Parser::BrowserEngine.new user_agent
      detector.call["name"].should eq "Edge"
    end
  end

  describe "Browser" do
    it "should extract browser name and version" do
      user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq "Microsoft Edge"
      result["version"].should eq "12.0"
    end

    it "should handle browser with no version" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq "Chrome"
      result["version"].should eq "120.0.0.0"
    end

    it "should handle browser with capture groups in version" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq "Chrome"
      result["version"].should eq "120.0.0.0"
    end

    it "should handle unknown browser gracefully" do
      user_agent = "SomeUnknownBrowser/1.0"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq ""
      result["version"].should eq ""
    end

    it "should handle empty user agent" do
      user_agent = ""
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq ""
      result["version"].should eq ""
    end

    it "should handle Firefox browser" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq "Firefox"
      result["version"].should eq "120.0"
    end

    it "should handle Safari browser" do
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Safari/605.1.15"
      detector = DeviceDetector::Parser::Browser.new user_agent
      result = detector.call
      result["name"].should eq "Safari"
      result["version"].should eq "17.1"
    end
  end

  describe "Camera" do
    it "should extract vendor and device" do
      user_agent = "Mozilla/5.0 (Linux; U; Android 2.3.3; ja-jp; COOLPIX S800c Build/CP01_WW) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
      detector = DeviceDetector::Parser::Camera.new user_agent
      result = detector.call
      result["vendor"].should eq "Nikon"
      result["device"].should eq "Coolpix S800c"
    end
  end

  describe "CarBrowser" do
    it "should extract model name and vendor" do
      user_agent = "Mozilla/5.0 (X11; u; Linux; C) AppleWebKit /533.3 (Khtml, like Gheko) QtCarBrowser Safari/533.3"
      detector = DeviceDetector::Parser::CarBrowser.new user_agent
      result = detector.call
      result["model"].should eq "Model S"
      result["vendor"].should eq "Tesla"
    end
  end

  describe "Console" do
    it "should extract vendor and model name" do
      user_agent = "Mozilla/5.0 (PLAYSTATION 3 4.46) AppleWebKit/531.22.8 (KHTML, like Gecko)"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Sony"
      result["model"].should eq "PlayStation 3"
    end

    it "should handle PlayStation 4" do
      user_agent = "Mozilla/5.0 (PlayStation 4 8.52) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Sony"
      result["model"].should eq "PlayStation 4"
    end

    it "should handle PlayStation 5" do
      user_agent = "Mozilla/5.0 (PlayStation 5 9.00) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Sony"
      result["model"].should eq "PlayStation 5"
    end

    it "should handle Xbox 360" do
      user_agent = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; Xbox)"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Microsoft"
      result["model"].should eq "Xbox 360"
    end

    it "should handle Nintendo Switch" do
      user_agent = "Mozilla/5.0 (Nintendo Switch; WifiWebAuthApplet) AppleWebKit/601.6 (KHTML, like Gecko) NF/6.0.0.11.1632 NintendoBrowser/5.79.11201.US"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Nintendo"
      result["model"].should eq "Switch"
    end

    it "should handle Nintendo 3DS" do
      user_agent = "Mozilla/5.0 (Nintendo 3DS; U; ; en) Version/1.7560.US"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq "Nintendo"
      result["model"].should eq "3DS"
    end

    it "should handle unknown console gracefully" do
      user_agent = "SomeUnknownConsole/1.0"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["model"].should eq ""
    end

    it "should handle empty user agent" do
      user_agent = ""
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["model"].should eq ""
    end

    it "should handle regular browser user agent" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::Console.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["model"].should eq ""
    end
  end

  describe "FeedReader" do
    it "should extract name and version" do
      user_agent = "FeeddlerRSS/2.4 CFNetwork/548.1.4 Darwin/11.0.0"
      detector = DeviceDetector::Parser::FeedReader.new user_agent
      result = detector.call
      result["name"].should eq "Feeddler RSS Reader"
      result["version"].should eq "2.4"
    end
  end

  describe "Library" do
    it "should extract name and version" do
      user_agent = "curl/7.21.0 (i386-redhat-linux-gnu) libcurl/7.21.0 NSS/3.12.10.0 zlib/1.2.5 libidn/1.18 libssh2/1.2.4"
      detector = DeviceDetector::Parser::Library.new user_agent
      result = detector.call
      result["name"].should eq "curl"
      result["version"].should eq "7.21.0"
    end
  end

  describe "Mediaplayer" do
    it "should extract name and version" do
      user_agent = "iTunes/10.2.1 (Macintosh; Intel Mac OS X 10.7) AppleWebKit/534.20.8"
      detector = DeviceDetector::Parser::Mediaplayer.new user_agent
      result = detector.call
      result["name"].should eq "iTunes"
      result["version"].should eq "10.2.1"
    end
  end

  describe "MobileApp" do
    it "should extract name and version" do
      user_agent = "WhatsApp/2.6.4 iPhone_OS/4.3.3 Device/iPhone_4"
      detector = DeviceDetector::Parser::MobileApp.new user_agent
      result = detector.call
      result["name"].should eq("WhatsApp")
      result["version"].should eq("2.6.4")
    end
  end

  describe "Mobile" do
    it "should extract vendor, model and type" do
      user_agent = "Mozilla/5.0 (Linux; Android 7.0; BV6000 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 YaBrowser/17.1.1.359.00 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Blackview"
      result["model"].should eq "BV6000"
      result["type"].should eq "smartphone"
    end

    it "should handle iPhone" do
      user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Apple"
      result["model"].should eq "iPhone "
      result["type"].should eq ""
    end

    it "should handle iPad" do
      user_agent = "Mozilla/5.0 (iPad; CPU OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Apple"
      result["model"].should eq "iPad"
      result["type"].should eq ""
    end

    it "should handle Samsung Galaxy" do
      user_agent = "Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Samsung"
      result["model"].should eq "SM-G991B"
      result["type"].should eq "smartphone"
    end

    it "should handle Google Pixel" do
      user_agent = "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Google"
      result["model"].should eq "Pixel 8"
      result["type"].should eq "smartphone"
    end

    it "should handle unknown mobile device gracefully" do
      user_agent = "SomeUnknownMobile/1.0"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["device"]?.should eq ""
      result["type"].should eq ""
    end

    it "should handle empty user agent" do
      user_agent = ""
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["device"]?.should eq ""
      result["type"].should eq ""
    end

    it "should handle regular desktop browser" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["device"]?.should eq ""
      result["type"].should eq ""
    end

    it "should handle mobile device with capture groups" do
      user_agent = "Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::Mobile.new user_agent
      result = detector.call
      result["vendor"].should eq "Samsung"
      result["model"].should eq "SM-G991B"
      result["type"].should eq "smartphone"
    end
  end

  describe "OS" do
    it "should extract name and version" do
      user_agent = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko Fedora/1.9.0.8-1.fc10 Kazehakase/0.5.6"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Fedora"
      result["version"].should eq "10"
    end

    it "should handle Windows 10" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Windows"
      result["version"].should eq "10"
    end

    it "should handle Windows 11" do
      user_agent = "Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Windows"
      result["version"].should eq "NT"
    end

    it "should handle macOS" do
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Safari/605.1.15"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Mac"
      result["version"].should eq "10_15_7"
    end

    it "should handle iOS" do
      user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "iOS"
      result["version"].should eq "17_1"
    end

    it "should handle Android with API level" do
      user_agent = "Mozilla/5.0 (Linux; Android API 34) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Android"
      result["version"].should eq "14"
    end

    it "should handle Android with version" do
      user_agent = "Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Android"
      result["version"].should eq "13"
    end

    it "should handle Ubuntu" do
      user_agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:120.0) Gecko/20100101 Firefox/120.0"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "Ubuntu"
      result["version"].should eq ""
    end

    it "should handle unknown OS gracefully" do
      user_agent = "SomeUnknownOS/1.0"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq ""
      result["version"].should eq ""
    end

    it "should handle empty user agent" do
      user_agent = ""
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq ""
      result["version"].should eq ""
    end

    it "should handle OS with capture groups" do
      user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      detector = DeviceDetector::Parser::OS.new user_agent
      result = detector.call
      result["name"].should eq "GNU/Linux"
      result["version"].should eq ""
    end
  end

  describe "PIM" do
    it "should extract name and version" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Win64; x64; Trident/7.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; InfoPath.3; .NET CLR 1.1.4322; FDM; Tablet PC 2.0; .NET4.0E; Microsoft Outlook 14.0.7113; ms-office; MSOffice 14)"
      detector = DeviceDetector::Parser::PIM.new user_agent
      result = detector.call
      result["name"] = "Microsoft Outlook"
      result["version"] = "14.0.7113"
    end
  end

  describe "Portable media player" do
    it "should extract vendor and model" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 6.12; Microsoft ZuneHD 4.3)"
      detector = DeviceDetector::Parser::PortableMediaPlayer.new user_agent
      result = detector.call
      result["vendor"].should eq "Microsoft"
      result["model"].should eq "Zune HD"
    end
  end

  describe "TV" do
    it "should extract vendor and model" do
      user_agent = "Opera/9.80 (Linux armv7l; HbbTV/1.2.1 (; Hisense; SmartTV_2015; V00.01.00a.G0816; HE65M7000UWTSG; )) Presto/2.12.407 Version/12.51 year/2016"
      detector = DeviceDetector::Parser::Television.new user_agent
      result = detector.call
      result["vendor"].should eq "Hisense"
      result["model"].should eq "HE65M7000UWTS"
    end

    it "should not have vendor or model of tv for browser UA" do
      user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
      detector = DeviceDetector::Parser::Television.new user_agent
      result = detector.call
      result["vendor"].should eq ""
      result["model"].should eq ""
    end
  end

  describe "VendorFragment" do
    it "should extract vendor" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; Media Center PC 6.0; MAAR; Tablet PC 2.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E)"
      detector = DeviceDetector::Parser::VendorFragment.new user_agent
      result = detector.call
      result["vendor"].should eq "Acer"
    end
  end
end

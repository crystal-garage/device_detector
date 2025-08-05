require "./spec_helper"

describe "Response" do
  describe "Base methods" do
    user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
    response = DeviceDetector::Detector.new(user_agent).call
    it "should return any data in expected structure" do
      response.raw.should be_truthy
      response.raw.should be_a(Array(Hash(String, Hash(String, String))))
    end
  end

  describe "Lite version" do
    user_agent = "Googlebot (gocrawl v0.4)"
    response = DeviceDetector::Detector.new(user_agent).lite

    it "should return true if bot detected" { response.bot?.should be_true }
    it "should return bot name" do
      response.bot.name.should eq("Googlebot")
    end
  end

  describe "Bot" do
    user_agent = "Googlebot (gocrawl v0.4)"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if bot detected" { response.bot?.should be_true }
    it "should return bot name" do
      response.bot.name.should eq("Googlebot")
    end
    it "should return bot producer name" do
      response.bot.producer.name.should eq("Google Inc.")
    end
    it "should return bot producer url" do
      response.bot.producer.url.should eq("https://www.google.com/")
    end
  end

  describe "BrowserEngine" do
    user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if engine detected" { response.browser_engine?.should be_true }
    it "should return engine name" do
      response.browser_engine.name.should eq "Edge"
    end
  end

  describe "Browser" do
    user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if browser detected" { response.browser?.should be_true }
    it "should return browser name" do
      response.browser.name.should eq "Microsoft Edge"
    end
    it "should return browser version" do
      response.browser.version.should eq "12.0"
    end
  end

  describe "Camera" do
    user_agent = "Mozilla/5.0 (Linux; U; Android 2.3.3; ja-jp; COOLPIX S800c Build/CP01_WW) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if camera detected" { response.camera?.should be_true }
    it "should return camera vendor" do
      response.camera.vendor.should eq "Nikon"
    end
    it "should return camera model" do
      response.camera.device.should eq "Coolpix S800c"
    end
  end

  describe "CarBrowser" do
    user_agent = "Mozilla/5.0 (X11; u; Linux; C) AppleWebKit /533.3 (Khtml, like Gheko) QtCarBrowser Safari/533.3"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if car browser detected" { response.car_browser?.should be_true }
    it "should return car browser vendor" do
      response.car_browser.vendor.should eq "Tesla"
    end
    it "should return car browser model" do
      response.car_browser.model.should eq "Model S"
    end
  end

  describe "Console" do
    user_agent = "Mozilla/5.0 (PLAYSTATION 3 4.46) AppleWebKit/531.22.8 (KHTML, like Gecko)"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if console detected" { response.console?.should be_true }
    it "should return console vendor" do
      response.console.vendor.should eq "Sony"
    end
    it "should return console model" do
      response.console.model.should eq "PlayStation 3"
    end
  end

  describe "FeedReader" do
    user_agent = "FeeddlerRSS/2.4 CFNetwork/548.1.4 Darwin/11.0.0"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if feedreader detected" { response.feed_reader?.should be_true }
    it "should return name" do
      response.feed_reader.name.should eq "Feeddler RSS Reader"
    end
    it "should return version" do
      response.feed_reader.version.should eq "2.4"
    end
  end

  describe "Library" do
    user_agent = "curl/7.21.0 (i386-redhat-linux-gnu) libcurl/7.21.0 NSS/3.12.10.0 zlib/1.2.5 libidn/1.18 libssh2/1.2.4"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if library detected" { response.library?.should be_true }
    it "should return name" do
      response.library.name.should eq "curl"
    end
    it "should return version" do
      response.library.version.should eq "7.21.0"
    end
  end

  describe "Mediaplayer" do
    user_agent = "iTunes/10.2.1 (Macintosh; Intel Mac OS X 10.7) AppleWebKit/534.20.8"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if mediaplayer detected" { response.mediaplayer?.should be_true }
    it "should return name" do
      response.mediaplayer.name.should eq "iTunes"
    end
    it "should return version" do
      response.mediaplayer.version.should eq "10.2.1"
    end
  end

  describe "MobileApp" do
    user_agent = "WhatsApp/2.6.4 iPhone_OS/4.3.3 Device/iPhone_4"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if mobile app detected" { response.mobile_app?.should be_true }
    it "should return name" do
      response.mobile_app.name.should eq "WhatsApp"
    end
    it "should return version" do
      response.mobile_app.version.should eq "2.6.4"
    end
  end

  describe "MobileDevice" do
    user_agent = "Mozilla/5.0 (Linux; Android 7.0; BV6000 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 YaBrowser/17.1.1.359.00 Mobile Safari/537.36"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if mobile device detected" { response.mobile_device?.should be_true }
    it "should return vendor" do
      response.mobile_device.vendor.should eq "Blackview"
    end
    it "should return type" do
      response.mobile_device.type.should eq "smartphone"
    end
    it "should return model" do
      response.mobile_device.model.should eq "BV6000"
    end
  end

  describe "OS" do
    user_agent = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko Fedora/1.9.0.8-1.fc10 Kazehakase/0.5.6"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if OS detected" { response.os?.should be_true }
    it "should return name" do
      response.os.name.should eq "Fedora"
    end
    it "should return version" do
      response.os.version.should eq "10"
    end
  end

  describe "Android SDK Level Api" do
    describe "API Level 34" do
      user_agent = "Mozilla/5.0 (Linux; Android API 34) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return true if OS detected" { response.os?.should be_true }
      it "should return Android name" do
        response.os.name.should eq "Android"
      end
      it "should return Android version 14 for API 34" do
        response.os.version.should eq "14"
      end
    end
  end

  describe "PIM" do
    user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Win64; x64; Trident/7.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; InfoPath.3; .NET CLR 1.1.4322; FDM; Tablet PC 2.0; .NET4.0E; Microsoft Outlook 14.0.7113; ms-office; MSOffice 14)"
    response = DeviceDetector::Detector.new(user_agent).call
    it "should return true if PIM detected" { response.pim?.should be_true }
    it "should return name" do
      response.pim.name.should eq "Microsoft Outlook"
    end
    it "should return version" do
      response.pim.version.should eq "14.0.7113"
    end
  end

  describe "PortableMediaPlayer" do
    user_agent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 6.12; Microsoft ZuneHD 4.3)"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if PIM detected" { response.portable_media_player?.should be_true }
    it "should return vendor" do
      response.portable_media_player.vendor.should eq "Microsoft"
    end
    it "should return model" do
      response.portable_media_player.model.should eq "Zune HD"
    end
  end

  describe "TV" do
    user_agent = "Opera/9.80 (Linux armv7l; HbbTV/1.2.1 (; Hisense; SmartTV_2015; V00.01.00a.G0816; HE65M7000UWTSG; )) Presto/2.12.407 Version/12.51 year/2016"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if TV detected" { response.tv?.should be_true }
    it "should return vendor" do
      response.tv.vendor.should eq "Hisense"
    end
    it "should return model" do
      response.tv.model.should eq "HE65M7000UWTS"
    end
  end

  describe "VendorFragment" do
    user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; Media Center PC 6.0; MAAR; Tablet PC 2.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E)"
    response = DeviceDetector::Detector.new(user_agent).call

    it "should return true if VendorFragment detected" { response.vendorfragment?.should be_true }
    it "should return vendor" do
      response.vendorfragment.vendor.should eq "Acer"
    end
  end

  describe "TrafficType" do
    describe "Bot" do
      user_agent = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
      response = DeviceDetector::Detector.new(user_agent).call
      it "should return true if traffic from bot" { response.traffic_type.should eq "bot" }
    end

    describe "Human" do
      user_agent = "Mozilla/5.0 (iPad; CPU OS 5_1 like Mac OS X; en-us) AppleWebKit/534.46 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"
      response = DeviceDetector::Detector.new(user_agent).call
      it "should return true if traffic from human" { response.traffic_type.should eq "human" }
    end
  end

  describe "Object-Oriented API" do
    describe "Browser Object" do
      user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return browser object with name" do
        response.browser.name.should eq "Microsoft Edge"
      end

      it "should return browser object with version" do
        response.browser.version.should eq "12.0"
      end

      it "should check browser name presence" do
        response.browser.name?.should be_true
      end

      it "should check browser version presence" do
        response.browser.version?.should be_true
      end
    end

    describe "OS Object" do
      user_agent = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko Fedora/1.9.0.8-1.fc10 Kazehakase/0.5.6"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return OS object with name" do
        response.os.name.should eq "Fedora"
      end

      it "should return OS object with version" do
        response.os.version.should eq "10"
      end

      it "should check OS name presence" do
        response.os.name?.should be_true
      end

      it "should check OS version presence" do
        response.os.version?.should be_true
      end
    end

    describe "Mobile Object" do
      user_agent = "Mozilla/5.0 (Linux; Android 7.0; BV6000 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 YaBrowser/17.1.1.359.00 Mobile Safari/537.36"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return mobile object with vendor" do
        response.mobile.vendor.should eq "Blackview"
      end

      it "should return mobile object with type" do
        response.mobile.type.should eq "smartphone"
      end

      it "should return mobile object with model" do
        response.mobile.model.should eq "BV6000"
      end

      it "should check mobile vendor presence" do
        response.mobile.vendor?.should be_true
      end

      it "should check mobile type presence" do
        response.mobile.type?.should be_true
      end

      it "should check mobile model presence" do
        response.mobile.model?.should be_true
      end
    end

    describe "Bot Object" do
      user_agent = "Googlebot (gocrawl v0.4)"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return bot object with name" do
        response.bot.name.should eq "Googlebot"
      end

      it "should check bot name presence" do
        response.bot.name?.should be_true
      end
    end

    describe "Browser Engine Object" do
      user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return browser engine object with name" do
        response.browser_engine.name.should eq "Edge"
      end

      it "should check browser engine name presence" do
        response.browser_engine.name?.should be_true
      end
    end

    describe "Camera Object" do
      user_agent = "Mozilla/5.0 (Linux; U; Android 2.3.3; ja-jp; COOLPIX S800c Build/CP01_WW) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return camera object with vendor" do
        response.camera.vendor.should eq "Nikon"
      end

      it "should return camera object with device" do
        response.camera.device.should eq "Coolpix S800c"
      end

      it "should check camera vendor presence" do
        response.camera.vendor?.should be_true
      end

      it "should check camera device presence" do
        response.camera.device?.should be_true
      end
    end

    describe "Car Browser Object" do
      user_agent = "Mozilla/5.0 (X11; u; Linux; C) AppleWebKit /533.3 (Khtml, like Gheko) QtCarBrowser Safari/533.3"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return car browser object with vendor" do
        response.car_browser.vendor.should eq "Tesla"
      end

      it "should return car browser object with model" do
        response.car_browser.model.should eq "Model S"
      end

      it "should check car browser vendor presence" do
        response.car_browser.vendor?.should be_true
      end

      it "should check car browser model presence" do
        response.car_browser.model?.should be_true
      end
    end

    describe "Console Object" do
      user_agent = "Mozilla/5.0 (PLAYSTATION 3 4.46) AppleWebKit/531.22.8 (KHTML, like Gecko)"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return console object with vendor" do
        response.console.vendor.should eq "Sony"
      end

      it "should return console object with model" do
        response.console.model.should eq "PlayStation 3"
      end

      it "should check console vendor presence" do
        response.console.vendor?.should be_true
      end

      it "should check console model presence" do
        response.console.model?.should be_true
      end
    end

    describe "Feed Reader Object" do
      user_agent = "FeeddlerRSS/2.4 CFNetwork/548.1.4 Darwin/11.0.0"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return feed reader object with name" do
        response.feed_reader.name.should eq "Feeddler RSS Reader"
      end

      it "should return feed reader object with version" do
        response.feed_reader.version.should eq "2.4"
      end

      it "should check feed reader name presence" do
        response.feed_reader.name?.should be_true
      end

      it "should check feed reader version presence" do
        response.feed_reader.version?.should be_true
      end
    end

    describe "Library Object" do
      user_agent = "curl/7.21.0 (i386-redhat-linux-gnu) libcurl/7.21.0 NSS/3.12.10.0 zlib/1.2.5 libidn/1.18 libssh2/1.2.4"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return library object with name" do
        response.library.name.should eq "curl"
      end

      it "should return library object with version" do
        response.library.version.should eq "7.21.0"
      end

      it "should check library name presence" do
        response.library.name?.should be_true
      end

      it "should check library version presence" do
        response.library.version?.should be_true
      end
    end

    describe "Media Player Object" do
      user_agent = "iTunes/10.2.1 (Macintosh; Intel Mac OS X 10.7) AppleWebKit/534.20.8"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return media player object with name" do
        response.mediaplayer.name.should eq "iTunes"
      end

      it "should return media player object with version" do
        response.mediaplayer.version.should eq "10.2.1"
      end

      it "should check media player name presence" do
        response.mediaplayer.name?.should be_true
      end

      it "should check media player version presence" do
        response.mediaplayer.version?.should be_true
      end
    end

    describe "Mobile App Object" do
      user_agent = "WhatsApp/2.6.4 iPhone_OS/4.3.3 Device/iPhone_4"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return mobile app object with name" do
        response.mobile_app.name.should eq "WhatsApp"
      end

      it "should return mobile app object with version" do
        response.mobile_app.version.should eq "2.6.4"
      end

      it "should check mobile app name presence" do
        response.mobile_app.name?.should be_true
      end

      it "should check mobile app version presence" do
        response.mobile_app.version?.should be_true
      end
    end

    describe "PIM Object" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Win64; x64; Trident/7.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; InfoPath.3; .NET CLR 1.1.4322; FDM; Tablet PC 2.0; .NET4.0E; Microsoft Outlook 14.0.7113; ms-office; MSOffice 14)"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return PIM object with name" do
        response.pim.name.should eq "Microsoft Outlook"
      end

      it "should return PIM object with version" do
        response.pim.version.should eq "14.0.7113"
      end

      it "should check PIM name presence" do
        response.pim.name?.should be_true
      end

      it "should check PIM version presence" do
        response.pim.version?.should be_true
      end
    end

    describe "Portable Media Player Object" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 6.12; Microsoft ZuneHD 4.3)"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return portable media player object with vendor" do
        response.portable_media_player.vendor.should eq "Microsoft"
      end

      it "should return portable media player object with model" do
        response.portable_media_player.model.should eq "Zune HD"
      end

      it "should check portable media player vendor presence" do
        response.portable_media_player.vendor?.should be_true
      end

      it "should check portable media player model presence" do
        response.portable_media_player.model?.should be_true
      end
    end

    describe "TV Object" do
      user_agent = "Opera/9.80 (Linux armv7l; HbbTV/1.2.1 (; Hisense; SmartTV_2015; V00.01.00a.G0816; HE65M7000UWTSG; )) Presto/2.12.407 Version/12.51 year/2016"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return TV object with vendor" do
        response.tv.vendor.should eq "Hisense"
      end

      it "should return TV object with model" do
        response.tv.model.should eq "HE65M7000UWTS"
      end

      it "should check TV vendor presence" do
        response.tv.vendor?.should be_true
      end

      it "should check TV model presence" do
        response.tv.model?.should be_true
      end
    end

    describe "Vendor Fragment Object" do
      user_agent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; Media Center PC 6.0; MAAR; Tablet PC 2.0; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E)"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should return vendor fragment object with vendor" do
        response.vendorfragment.vendor.should eq "Acer"
      end

      it "should check vendor fragment vendor presence" do
        response.vendorfragment.vendor?.should be_true
      end
    end

    describe "Empty Object Handling" do
      user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
      response = DeviceDetector::Detector.new(user_agent).call

      it "should handle empty mobile object gracefully" do
        response.mobile.vendor.should eq ""
        response.mobile.type.should eq ""
        response.mobile.model.should be_nil
      end

      it "should handle empty bot object gracefully" do
        response.bot.name.should eq ""
      end

      it "should handle empty camera object gracefully" do
        response.camera.vendor.should eq ""
        response.camera.device.should eq ""
      end

      it "should check presence methods work correctly" do
        response.mobile.vendor?.should be_false
        response.bot.name?.should be_false
        response.camera.vendor?.should be_false
      end
    end
  end
end

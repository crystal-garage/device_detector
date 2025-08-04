require "../src/device_detector"
require "benchmark"

COUNT = 1000

# Diverse set of user agents for realistic testing
user_agents = [
  "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Mobile/15E148 Safari/604.1",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Linux; Android 11; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (iPad; CPU OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Mobile/15E148 Safari/604.1",
  "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
  "Mozilla/5.0 (compatible; Bingbot/2.0; +http://www.bing.com/bingbot.htm)",
  "Mozilla/5.0 (compatible; Facebookexternalhit/1.1; +http://www.facebook.com/externalhit_uatext.php)",
  "Mozilla/5.0 (compatible; Twitterbot/1.0)",
  "Mozilla/5.0 (compatible; LinkedInBot/1.0)",
  "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)",
  "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)",
  "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)",
  "Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)",
  "Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)",
  "Mozilla/5.0 (compatible; DotBot/1.2; +http://www.opensiteexplorer.org/dotbot; help@moz.com)",
  "Mozilla/5.0 (compatible; BLEXBot/1.0; +http://webmeup-crawler.com/)",
  "Mozilla/5.0 (compatible; ia_archiver (+http://www.alexa.com/site/help/webmasters); crawler@alexa.com)",
]

Benchmark.bm do |x|
  x.report("full:") do
    COUNT.times do
      user_agent = user_agents.sample
      detector = DeviceDetector::Detector.new(user_agent)
      detector.call.raw
    end
  end

  x.report("lite:") do
    COUNT.times do
      user_agent = user_agents.sample
      detector = DeviceDetector::Detector.new(user_agent)
      detector.lite.raw
    end
  end
end

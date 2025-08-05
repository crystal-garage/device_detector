# Device Detector

[![Crystal CI](https://github.com/mamantoha/device_detector/actions/workflows/crystal.yml/badge.svg?branch=develop)](https://github.com/mamantoha/device_detector/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/crystal-garage/device_detector.svg)](https://github.com/crystal-garage/device_detector/releases)
[![License](https://img.shields.io/github/license/crystal-garage/device_detector.svg)](https://github.com/crystal-garage/device_detector/blob/master/LICENSE)

The library for parsing User Agent and browser, operating system, device used (desktop, tablet, mobile, tv, cars, console, etc.), vendor and model detection.

* Support latest Crystal version and update script for private use or immediately updates.
* The Library uses regexes from [matomo-org/device-detector](https://github.com/matomo-org/device-detector).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  device_detector:
    github: crystal-garage/device_detector
```

Then run `shards install`

## Usage

```Crystal
require "device_detector"

user_agent = "Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36 Edge/12.0"

response = DeviceDetector::Detector.new(user_agent).call

response.browser? # => true
response.browser.name # => "Microsoft Edge"
response.browser.version # => "12.0"

pp response.raw

[{"bot" => {"name" => ""}},
 {"browser" => {"name" => "Microsoft Edge", "version" => "12.0"}},
 {"browser_engine" => {"name" => "Edge"}},
 {"camera" => {"vendor" => "", "model" => "", "device" => ""}},
 {"car_browser" => {"vendor" => "", "device" => "", "model" => ""}},
 {"console" => {"vendor" => "", "model" => ""}},
 {"feed_reader" => {"name" => "", "version" => ""}},
 {"library" => {"name" => "", "version" => ""}},
 {"mediaplayer" => {"name" => "", "version" => ""}},
 {"mobile_app" => {"name" => "", "version" => ""}},
 {"mobile" => {"device" => "", "vendor" => "", "type" => ""}},
 {"os" => {"name" => "Windows", "version" => "10"}},
 {"pim" => {"name" => "", "version" => ""}},
 {"portable_media_player" => {"vendor" => "", "model" => ""}},
 {"tv" => {"model" => "", "vendor" => ""}},
 {"vendorfragment" => {"vendor" => ""}}]
```

Available methods:

<table>
  <tr>
    <td><strong>Bot</strong><br />bot?<br />bot.name<br />bot.category<br />bot.url<br />bot.producer.name<br />bot.producer.url</td>
    <td><strong>Browser Engine</strong><br />browser_engine?<br />browser_engine.name</td>
    <td><strong>Browser</strong><br />browser?<br />browser.name<br />browser.version</td>
  </tr>
  <tr>
    <td><strong>Camera</strong><br />camera?<br />camera.device<br />camera.vendor</td>
    <td><strong>Car Browser</strong><br />car_browser?<br />car_browser.model<br />car_browser.vendor</td>
    <td><strong>Console</strong><br />console?<br />console.model<br />console.vendor</td>
  </tr>
  <tr>
    <td><strong>Feed Reader</strong><br />feed_reader?<br />feed_reader.name<br />feed_reader.version</td>
    <td><strong>Library</strong><br />library?<br />library.name<br />library.version</td>
    <td><strong>Media Player</strong><br />mediaplayer?<br />mediaplayer.name<br />mediaplayer.version</td>
  </tr>
  <tr>
    <td><strong>Mobile App</strong><br />mobile_app?<br />mobile_app.name<br />mobile_app.version</td>
    <td><strong>Mobile</strong><br />mobile?<br />mobile.vendor<br />mobile.type<br />mobile.model</td>
    <td><strong>OS</strong><br />os?<br />os.name<br />os.version</td>
  </tr>
  <tr>
    <td><strong>PIM</strong><br />pim?<br />pim.name<br />pim.version</td>
    <td><strong>Portable Media Player</strong><br />portable_media_player?<br />portable_media_player.model<br />portable_media_player.vendor</td>
    <td><strong>TV</strong><br />tv?<br />tv.model<br />tv.vendor</td>
  </tr>
  <tr>
    <td><strong>Vendor Fragment</strong><br />vendorfragment?<br />vendorfragment.vendor</td>
    <td></td>
    <td></td>
  </tr>
</table>

**Note**: The old API methods (like `browser_name`, `os_version`, etc.) are deprecated.

## Benchmark

```bash
crystal run ./bench/raw_response.cr --release
```

**Results:**

```
            user     system      total        real
full:   1.645194   0.025706   1.670900 (  1.677467)
lite:   0.766103   0.007790   0.773893 (  0.777249)
```

It's mean that `device_detector` can work with 1000 / 1.68 ~ 595 QPS (full) and 1000 / 0.78 ~ 1282 QPS (lite).

*Note: This benchmark uses 20 diverse user agents including browsers, mobile devices, and bots for realistic performance measurement.*

## Testing

```
crystal spec
```

## Update regexes

```
crystal scripts/update_regexes.cr
```

## Contributing

1. Fork it ( https://github.com/crystal-garage/device_detector/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [@creadone](https://github.com/creadone) Sergey Fedorov - creator, maintainer
- [@delef](https://github.com/delef) Ivan Palamarchuk - new api, code optimization
- [@zaycker](https://github.com/zaycker) Yuriy Zaitsev - fix check order
- [@mamantoha](https://github.com/mamantoha) Anton Maminov - maintainer

# Cuberto's development lab:

Cuberto is a leading digital agency with solid design and development expertise. We build mobile and web products for startups. Drop us a line.

# rubber-range-picker

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Cuberto/rubber-range-picker/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/rubber-range-picker.svg?style=flat)](http://cocoapods.org/pods/rubber-range-picker)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg?style=flat)](https://developer.apple.com/swift/)

<!-- ![Animation](https://raw.githubusercontent.com/Cuberto/liquid-swipe/master/Screenshots/animation.gif) -->

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.3+
- Xcode 10

## Installation

rubber-range-picker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'rubber-range-picker'
```
Then run `pod install`.

Do not forget to run `pod repo update` if spec not found

## Usage

Set `RubberRangePicker` as class for custom view in interface builder, or instantiate it from manualy from code.

Use `minimumValue`/`maximumValue` to set border values, and `lowerValue`/`upperValue` to get or set selected values.

Target-action model (valueChanged) can be used to monitor selection changes.

There are some parameters that determine animation behavior, use sample app to check them and find values satisfying your needs.

## Author

Cuberto Design, info@cuberto.com

## License

rubber-range-picker is available under the MIT license. See the LICENSE file for more info.

# YYImage Integration Guide

## Current Setup

YYImage files are located in `ios/Classes/` directory and are imported via bridging header.

## Files Included
- YYImage.h/m
- YYImageCoder.h/m
- YYAnimatedImageView.h/m
- YYFrameImage.h/m
- YYSpriteSheetImage.h/m

## Bridging Header

In `ios/Classes/Runner-Bridging-Header.h`:

```objc
// #import <YYImage/YYImage.h>
#import "YYImageCoder.h"
```

## Usage in Swift

After adding the header import, you can use YYImage classes directly in Swift:

```swift
// YYImageDecoder
let decoder = YYImageDecoder(data: data, scale: 1.0)
let frameCount = decoder.frameCount

// YYImageEncoder
let encoder = YYImageEncoder(type: .webP)
encoder.addImage(image)
let webpData = encoder.encode()
```

## Podspec Configuration

The `whatsapp_stickers_injector.podspec` includes:
- `HEADER_SEARCH_PATHS` for finding headers
- `CLANG_ENABLE_MODULES` for module support
- `DEFINES_MODULE` for framework creation

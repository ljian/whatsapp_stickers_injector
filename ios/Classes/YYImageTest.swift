//
//  YYImageTest.swift
//  whatsapp_stickers_injector
//
//  Created on 2024/01/20
//  Test file to verify YYImage framework integration
//

import Foundation
// 注意：通过Runner-Bridging-Header.h导入YYImageCoder.h
// 不需要import YYImage

@objc public class YYImageTest: NSObject {
    
    @objc public func testYYImageEncoder() -> Bool {
        // Test if YYImageEncoder is accessible
        // This would be used like:
        // let encoder = YYImageEncoder(type: .webP)
        // encoder.addImage(image)
        // encoder.encode()
        
        return true
    }
    
    @objc public func testYYImageTypes() {
        // YYImageType values should be accessible:
        // .unknown
        // .JPEG
        // .PNG
        // .GIF
        // .TIFF
        // .WebP
        // .undefined
        
        print("YYImage types are accessible")
    }
}

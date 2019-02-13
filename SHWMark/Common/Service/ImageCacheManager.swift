//
//  ImageCacheManager.swift
//  SHWMark
//
//  Created by yehot on 2018/1/4.
//  Copyright © 2018年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import Kingfisher

class ImageCacheManager {
    static func setupKingFisherCacheLimit(_ size: UInt) {
        ImageCache.default.maxDiskCacheSize = size
        // default 7天
        //ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * 3
    }

    /// 单位： bytes
    static func getCurrentCacheSize(completion handler: @escaping ((_ size: UInt) -> ())) {
        return ImageCache.default.calculateDiskCacheSize { size in
            handler(size)
        }
    }
    
    static func clearDiskCache() {
        ImageCache.default.clearDiskCache()
    }
}

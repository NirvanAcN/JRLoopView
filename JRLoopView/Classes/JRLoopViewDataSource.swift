//
//  JRLoopViewDataSource.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/31.
//  Copyright © 2017年 京睿. All rights reserved.
//

import Foundation
import UIKit

public protocol JRLoopViewDataSource: NSObjectProtocol {
    func loopView(imagesSourceType loopView: JRLoopView) -> JRLoopViewDataSourceType

    func loopView(imagesNameFor loopView: JRLoopView) -> [String]
    
    func loopView(imagesURLFor loopView: JRLoopView) -> [URL]
    
    func loopView(imagesURLStringFor loopView: JRLoopView) -> [String]
    
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode
}

public extension JRLoopViewDataSource {
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode {
        return .scaleToFill
    }
    
    func loopView(imagesNameFor loopView: JRLoopView) -> [String] {
        return []
    }
    
    func loopView(imagesURLFor loopView: JRLoopView) -> [URL] {
        return []
    }
    
    func loopView(imagesURLStringFor loopView: JRLoopView) -> [String] {
        return []
    }
}

/// 数据源类型
///
/// - url: 网络图片url
/// - urlString: 网络图片urlstring
/// - name: 本地图片name
public enum JRLoopViewDataSourceType {
    case url, urlString, name
}

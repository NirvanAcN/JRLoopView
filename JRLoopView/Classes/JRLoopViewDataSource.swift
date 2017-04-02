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
    /// 设置加载图片的方式
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: 网络图片.url, 网络图片.urlString, 本地图片.name
    func loopView(imagesSourceType loopView: JRLoopView) -> JRLoopViewDataSourceType

    /// 本地图片names
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: names
    func loopView(imagesNameFor loopView: JRLoopView) -> [String]
    
    /// 网络图片urls
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: urls
    func loopView(imagesURLFor loopView: JRLoopView) -> [URL]
    
    /// 网络图片urlStrings
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: url strings
    func loopView(imagesURLStringFor loopView: JRLoopView) -> [String]
        
    /// 设置占位图
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: 占位图
    func loopView(placeHolderFor loopView: JRLoopView) -> UIImage!
    
    /// 设置图片ContentMode
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: UIViewContentMode 默认为scaleToFill
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode
    
    /// 设置是否开启自动滚动
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: Bool 默认为false
    func loopView(isAutoLoopFor loopView: JRLoopView) -> Bool
    
    /// 设置自动滚动时间间隔
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: TimeInterval 默认为5s
    func loopView(autoLoopTimeIntervalFor loopView: JRLoopView) -> TimeInterval
    
    /// 设置是否显示PageControl
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: Bool 默认为false
    func loopView(isShowPageControlFor loopView: JRLoopView) -> Bool
    
    /// 设置初始状态显示第几张图片 若发生越界此则设置无效
    ///
    /// - Parameter loopView: loopView description
    /// - Returns: Int 默认0
    func loopView(currentPageFor loopView: JRLoopView) -> Int
}

public extension JRLoopViewDataSource {
    
    func loopView(imagesNameFor loopView: JRLoopView) -> [String] {
        return []
    }
    
    func loopView(imagesURLFor loopView: JRLoopView) -> [URL] {
        return []
    }
    
    func loopView(imagesURLStringFor loopView: JRLoopView) -> [String] {
        return []
    }
    
    func loopView(placeHolderFor loopView: JRLoopView) -> UIImage! {
        return nil
    }
    
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode {
        return .scaleToFill
    }
    
    func loopView(autoLoopTimeIntervalFor loopView: JRLoopView) -> TimeInterval {
        return 5.JRSeconds
    }
    
    func loopView(isAutoLoopFor loopView: JRLoopView) -> Bool {
        return false
    }
    
    func loopView(isShowPageControlFor loopView: JRLoopView) -> Bool {
        return false
    }
    
    func loopView(currentPageFor loopView: JRLoopView) -> Int {
        return 0
    }
}

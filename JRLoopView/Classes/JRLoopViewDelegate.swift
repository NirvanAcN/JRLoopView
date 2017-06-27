//
//  JRLoopViewDelegate.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/31.
//  Copyright © 2017年 京睿. All rights reserved.
//

import Foundation
import UIKit

public protocol JRLoopViewDelegate: NSObjectProtocol {
    /// 图片点击事件
    ///
    /// - Parameters:
    ///   - loopView: loopView description
    ///   - index: 被点击图片的index
    func loopView(_ loopView: JRLoopView, didSelectAt index: Int)
    
    /// 当前页码
    ///
    /// - Parameters:
    ///   - loopView: loopView description
    ///   - page: 当前页码
    ///   - number: 总页数
    func loopView(_ loopView: JRLoopView, current page: Int, total number: Int)
}

public extension JRLoopViewDelegate {
    func loopView(_ loopView: JRLoopView, didSelectAt index: Int) { }
    
    func loopView(_ loopView: JRLoopView, current page: Int, total number: Int) { }
}

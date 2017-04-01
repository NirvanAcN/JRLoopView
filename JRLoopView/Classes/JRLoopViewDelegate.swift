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
    func loopView(_ loopView: JRLoopView, didSelectAt index: Int)
}

public extension JRLoopViewDelegate {
    func loopView(_ loopView: JRLoopView, didSelectAt index: Int) {
        
    }
}

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
    func loopView(imagesNameFor loopView: JRLoopView) -> [String]
    
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode
}

extension JRLoopViewDataSource {
    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode {
        return .scaleToFill
    }
}

//
//  JRLoopViewConfiguration.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/31.
//  Copyright © 2017年 京睿. All rights reserved.
//

import Foundation
import UIKit

class JRLoopViewConfiguration {
//    private override init() { }
    
    class func JRScrollViewConfiguration(_ scrollView: UIScrollView) {
        scrollView.backgroundColor = UIColor.white
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
    }
}

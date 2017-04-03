//
//  JRTimeInterval.swift
//  JRTimer
//
//  Created by 京睿 on 2017/4/1.
//  Copyright © 2017年 京睿. All rights reserved.
//

import Foundation

// MARK: - p5.直观的时间展示（日/时/分/秒/毫秒）
public extension Double {
    var JRMilliseconds:   TimeInterval    { return self / 1000 }
    var JRSeconds:        TimeInterval    { return self }
    var JRMinutes:        TimeInterval    { return JRSeconds * 60 }
    var JRHours:          TimeInterval    { return JRMinutes * 60 }
    var JRDays:           TimeInterval    { return JRHours * 24 }
}

public extension Int {
    var JRMilliseconds:   TimeInterval    { return TimeInterval(self / 1000) }
    var JRSeconds:        TimeInterval    { return TimeInterval(self) }
    var JRMinutes:        TimeInterval    { return JRSeconds * 60 }
    var JRHours:          TimeInterval    { return JRMinutes * 60 }
    var JRDays:           TimeInterval    { return JRHours * 24 }
}

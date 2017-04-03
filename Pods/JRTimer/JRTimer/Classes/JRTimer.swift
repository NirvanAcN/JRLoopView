//
//  JRTimer.swift
//  JRTimer
//
//  Created by 京睿 on 2017/4/1.
//  Copyright © 2017年 京睿. All rights reserved.
//

import Foundation

public extension Timer {
    typealias TimerNormalAction = ((Timer)->())
    typealias TimerDelayAction  = (()->())
    
    /// p1.添加一个自定义Timer初始化类方法
    ///
    /// - Parameters:
    ///   - timeInterval: 间隔时间长度
    ///   - repeats: 是否循环
    ///   - event: 事件
    /// - Returns: Timer
    public class func JRScheduledTimer(timeInterval: TimeInterval, repeats: Bool, event: TimerNormalAction!) -> Timer {
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(onTimerValueChange), userInfo:event, repeats: repeats)
        return timer
    }
    
    /// p3.添加每隔特定时间调用一次Timer
    ///
    /// - Parameters:
    ///   - timeInterval: 时间间隔长度
    ///   - event: 事件
    /// - Returns: Timer
    @discardableResult
    public class func JREvery(_ timeInterval: TimeInterval, _ event: TimerNormalAction!) -> Timer {
        let timer = Timer.JRScheduledTimer(timeInterval: timeInterval, repeats: true, event: event)
        timer.JRStart()
        return timer
    }
    
    /// p4.添加延迟特定时间调用Timer
    ///
    /// - Parameters:
    ///   - timeInterval: 延迟时间
    ///   - event: 事件
    public class func JRAfter(_ timeInterval: TimeInterval, _ event: TimerDelayAction!){
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(onDelayTimerValueChange), userInfo:event, repeats: false)
        timer.JRStart()
    }
    
    @objc private class func onTimerValueChange(_ sender: Timer) {
        guard let event = sender.userInfo as? TimerNormalAction else { return }
        event(sender)
    }
    
    @objc private class func onDelayTimerValueChange(_ sender: Timer) {
        guard let event = sender.userInfo as? TimerDelayAction else { return }
        event()
        sender.invalidate()
    }
    
    /// p2.添加Timer的启动函数
    ///
    /// - Parameters:
    ///   - runloop: runloop
    ///   - forMode: forMode
    public func JRStart(_ runloop: RunLoop = .current, _ forMode: RunLoopMode = .defaultRunLoopMode) {
        runloop.add(self, forMode: forMode)
    }
}

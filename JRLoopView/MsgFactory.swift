//
//  MsgFactory.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/31.
//  Copyright © 2017年 京睿. All rights reserved.
//

import UIKit

// 0 详情
// 1 付款

class MsgFactory: NSObject {
    class func manager(type: Int) -> MsgInterface {
        switch type {
        case 0:
            return JumpToDetail()
            
        default:
            return JumpToPay()
        }
    }
}

/// 类族
protocol MsgInterface {
    func doSomething()
}

class JumpToDetail: MsgInterface {
    func doSomething() {
        print("去看详情")
    }
}

class JumpToPay: MsgInterface {
    func doSomething() {
        print("去付款")
    }
}

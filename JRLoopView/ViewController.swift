//
//  ViewController.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/30.
//  Copyright © 2017年 京睿. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loopView: JRLoopView!
    
    var data = [
        "http://image.jingruiwangke.com/p/p8e4b9d1f3d5149fa818c89fe83e914f2.png",
        "http://image.jingruiwangke.com/p/p9d1ad504e31f4ea382f4827488d04b46.png",
        "http://image.jingruiwangke.com/p/pfe5405ba62a94ee8bdefe3f6693eb1a5.png",
        "http://image.jingruiwangke.com/p/p8e4b9d1f3d5149fa818c89fe83e914f2.png",
        "http://image.jingruiwangke.com/p/p9d1ad504e31f4ea382f4827488d04b46.png",
        "http://image.jingruiwangke.com/p/pfe5405ba62a94ee8bdefe3f6693eb1a5.png",
        "http://image.jingruiwangke.com/p/p8e4b9d1f3d5149fa818c89fe83e914f2.png",
        "http://image.jingruiwangke.com/p/p9d1ad504e31f4ea382f4827488d04b46.png",
        "http://image.jingruiwangke.com/p/pfe5405ba62a94ee8bdefe3f6693eb1a5.png"
    ]
    
    var type: JRLoopViewDataSourceType = .urlString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        let foo = JRLoopView.loopView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 200))
        //        view.addSubview(foo)
        
//        data = ["5.jpeg", "4.jpeg"]
        
        loopView.delegate = self
        loopView.dataSource = self
    }
    
    @IBAction func click(_ sender: UIButton) {
        type = .name
        data = ["5.jpeg", "4.jpeg", "2.jpg"]
        loopView.reloadData()
    }
}

extension ViewController: JRLoopViewDataSource {
    func loopView(imagesSourceType loopView: JRLoopView) -> JRLoopViewDataSourceType {
        return type
    }

    func loopView(imagesURLStringFor loopView: JRLoopView) -> [String] {
        return data
    }
    
    func loopView(imagesNameFor loopView: JRLoopView) -> [String] {
        return data
    }
    
    func loopView(placeHolderFor loopView: JRLoopView) -> UIImage! {
        return UIImage.init(named: "2.jpg")
    }
    
//    func loopView(contentModeFor loopView: JRLoopView) -> UIViewContentMode {
//        return .scaleAspectFit
//    }
    
    func loopView(autoLoopFor loopView: JRLoopView) -> Bool {
        return true
    }
    
    func loopView(autoLoopTimeIntervalFor loopView: JRLoopView) -> TimeInterval {
        return 1.JRSeconds
    }
    
    func loopView(isShowPageControlFor loopView: JRLoopView) -> Bool {
        return true
    }
    
    func loopView(currentPageFor loopView: JRLoopView) -> Int {
        return 50
    }
}

extension ViewController: JRLoopViewDelegate {
    func loopView(_ loopView: JRLoopView, didSelectAt index: Int) {
        print(index)
    }
}

//
//  JRLoopView.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/30.
//  Copyright © 2017年 京睿. All rights reserved.
//

import UIKit
import SDWebImage

open class JRLoopView: UIView {
    
    public weak var delegate:   JRLoopViewDelegate!
    public weak var dataSource: JRLoopViewDataSource! {
        didSet {
            config()
        }
    }
    
    private var scroll:     UIScrollView!
    private var helperView: UIView!
    
    private var lImageView: UIImageView!
    private var cImageView: UIImageView!
    private var rImageView: UIImageView!
    
    fileprivate var cIndex = 0
    
    public func reloadData() {
        setOrigins()
    }
    
    private var source: [String]! {
        return dataSource?.loopView(imagesNameFor: self)
    }
    
    public class func loopView(frame: CGRect) -> JRLoopView {
        let view = JRLoopView.init(frame: frame)
        return view
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func config() {
        backgroundColor = UIColor.white
        
        guard let _ = dataSource?.loopView(imagesNameFor: self) else { return }
        customScrollView()
    }
    
    /// 添加ScrollView
    private func customScrollView() {
        scroll = UIScrollView()
        JRLoopViewConfiguration.JRScrollViewConfiguration(scroll)
        scroll.delegate = self
        addSubview(scroll)
        NSLayoutConstraint.init(item: scroll, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: scroll, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: scroll, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: scroll, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        helperView = UIView()
        helperView.backgroundColor = UIColor.white
        helperView.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(helperView)
        NSLayoutConstraint.init(item: helperView, attribute: .leading, relatedBy: .equal, toItem: scroll, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: helperView, attribute: .top, relatedBy: .equal, toItem: scroll, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: helperView, attribute: .trailing, relatedBy: .equal, toItem: scroll, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: helperView, attribute: .bottom, relatedBy: .equal, toItem: scroll, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: helperView, attribute: .height, relatedBy: .equal, toItem: scroll, attribute: .height, multiplier: 1, constant: 0).isActive = true // *
        NSLayoutConstraint.init(item: helperView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: bounds.size.width * 3).isActive = true // *
        
        customImageViews()
    }
    
    /// 添加三个imageview
    private func customImageViews() {
        lImageView = UIImageView()
        imageViewsCommonConfig(lImageView)
        helperView.addSubview(lImageView)
        NSLayoutConstraint.init(item: lImageView, attribute: .leading, relatedBy: .equal, toItem: helperView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: lImageView, attribute: .top, relatedBy: .equal, toItem: helperView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: lImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: bounds.size.width).isActive = true
        NSLayoutConstraint.init(item: lImageView, attribute: .bottom, relatedBy: .equal, toItem: helperView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        cImageView = UIImageView()
        imageViewsCommonConfig(cImageView)
        helperView.addSubview(cImageView)
        NSLayoutConstraint.init(item: cImageView, attribute: .leading, relatedBy: .equal, toItem: lImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: cImageView, attribute: .top, relatedBy: .equal, toItem: lImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: cImageView, attribute: .width, relatedBy: .equal, toItem: lImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: cImageView, attribute: .bottom, relatedBy: .equal, toItem: lImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        rImageView = UIImageView()
        imageViewsCommonConfig(rImageView)
        helperView.addSubview(rImageView)
        NSLayoutConstraint.init(item: rImageView, attribute: .leading, relatedBy: .equal, toItem: cImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: rImageView, attribute: .top, relatedBy: .equal, toItem: cImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: rImageView, attribute: .width, relatedBy: .equal, toItem: cImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: rImageView, attribute: .bottom, relatedBy: .equal, toItem: cImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        setOrigins()
        setCurrent()
    }
    
    private func imageViewsCommonConfig(_ imageView: UIImageView) {
        let mode = dataSource?.loopView(contentModeFor: self)
        imageView.backgroundColor = UIColor.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = mode ?? .scaleToFill
    }
    
    /// 设置初始图片
    fileprivate func setOrigins() {
        if source.count == 0 {
            scroll.isScrollEnabled = false
        } else if source.count == 1 {
            scroll.isScrollEnabled = false
            set(image: cImageView, by: source.first!)
        } else {
            scroll.isScrollEnabled = true
            let indexs = prepareIndexs(by: source, centerIndex: &cIndex)
            set(image: lImageView, by: source[indexs.0])
            set(image: cImageView, by: source[indexs.1])
            set(image: rImageView, by: source[indexs.2])
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - imageView: <#imageView description#>
    ///   - value: <#value description#>
    private func set(image imageView: UIImageView, by value: String) {
        if let url = URL.init(string: value) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: value))
        } else {
            imageView.image = UIImage.init(named: value)
        }
    }
    
    /// 设置偏移量
    private func setCurrent() {
        let point = CGPoint.init(x: bounds.size.width, y: 0)
        layoutIfNeeded()
        scroll.setContentOffset(point, animated: false)
    }
    
    /// 获取偏移量
    ///
    /// - Parameters:
    ///   - source: 数据源
    ///   - centerIndex: 中位偏移量
    /// - Returns: 左偏移量、中偏移量、右偏移量
    private func prepareIndexs(by source: [Any], centerIndex: inout Int) -> (Int, Int, Int) {
        if source.count == 0 {
            return (0, 0, 0)
        } else if centerIndex == -1 || centerIndex == source.count - 1 {
            centerIndex = source.count - 1
            return (centerIndex - 1, centerIndex, 0)
        } else if centerIndex == source.count || centerIndex == 0 {
            centerIndex = 0
            return (source.count - 1, centerIndex, centerIndex + 1)
        } else {
            return (centerIndex - 1, centerIndex, centerIndex + 1)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension JRLoopView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let current = Int(ceil(scrollView.contentOffset.x / bounds.size.width))
        let point = CGPoint.init(x: bounds.size.width, y: 0)
        scrollView.setContentOffset(point, animated: false)
        cIndex += current - 1
        setOrigins()
    }
}

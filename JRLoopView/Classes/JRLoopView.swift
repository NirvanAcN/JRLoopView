//
//  JRLoopView.swift
//  JRLoopView
//
//  Created by 京睿 on 2017/3/30.
//  Copyright © 2017年 京睿. All rights reserved.
//

import UIKit
import SDWebImage
import JRTimer
import SnapKit

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
    
    private var timer: Timer!
    
    private var pageControl: UIPageControl!
    
    fileprivate var cIndex = 0
    
    fileprivate var source: [Any] {
        switch dataSource!.loopView(imagesSourceType: self) {
        case .url:
            guard let urls = dataSource?.loopView(imagesURLFor: self) else {
                fatalError("loopView(imagesURLFor:)")
            }
            return urls
            
        case .urlString:
            guard let urlStrings = dataSource?.loopView(imagesURLStringFor: self) else {
                fatalError("loopView(imagesURLStringFor:)")
            }
            return urlStrings
            
        case .name:
            guard let names = dataSource?.loopView(imagesNameFor: self) else {
                fatalError("loopView(imagesNameFor:)")
            }
            return names
        }
    }
    
    public func reloadData() {
        setDefaultCurrentPage()
        pageControlConfig()
        setOrigins()
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
        
        setDefaultCurrentPage()
        customScrollView()
    }
    
    /// 设置初始状态显示第几张图片
    private func setDefaultCurrentPage() {
        if let indx = dataSource?.loopView(currentPageFor: self), indx < source.count, indx >= 0 {
            cIndex = indx
        } else {
            cIndex = 0
        }
    }
    
    /// 添加ScrollView
    private func customScrollView() {
        scroll = UIScrollView()
        JRLoopViewConfiguration.JRScrollViewConfiguration(scroll)
        addTapGesture(scroll)
        scroll.delegate = self
        addSubview(scroll)
        scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        helperView = UIView()
        helperView.backgroundColor = UIColor.white
        scroll.addSubview(helperView)
        helperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(self).multipliedBy(3)
        }
        
        customImageViews()
    }
    
    private func addTapGesture(_ scrollView: UIScrollView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        delegate?.loopView(self, didSelectAt: cIndex)
    }
    
    /// 添加三个imageview
    private func customImageViews() {
        lImageView = UIImageView()
        imageViewsCommonConfig(lImageView)
        helperView.addSubview(lImageView)
        lImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalTo(helperView)
            $0.width.equalTo(self)
        }
        
        cImageView = UIImageView()
        imageViewsCommonConfig(cImageView)
        helperView.addSubview(cImageView)
        cImageView.snp.makeConstraints {
            $0.leading.equalTo(lImageView.snp.trailing)
            $0.top.bottom.width.equalTo(lImageView)
        }
        
        rImageView = UIImageView()
        imageViewsCommonConfig(rImageView)
        helperView.addSubview(rImageView)
        rImageView.snp.makeConstraints {
            $0.leading.equalTo(cImageView.snp.trailing)
            $0.top.bottom.width.equalTo(cImageView)
        }
        
        customPageControl()
        setOrigins()
//        setCurrent()
    }
    
    /// 添加UIPageControl
    private func customPageControl() {
        pageControl = UIPageControl.init()
        pageControl.isUserInteractionEnabled = false
        //        pageControl.pageIndicatorTintColor = UIColor.cyan
        //        pageControl.currentPageIndicatorTintColor = UIColor.cyan
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.bottom.equalTo(self)
        }
        
        pageControlConfig()
    }
    
    private func pageControlConfig() {
        guard let flag = dataSource?.loopView(isShowPageControlFor: self) else { return }
        pageControl.isHidden = !(flag && source.count > 1)
        pageControl.numberOfPages = source.count
        pageControl.currentPage = 0
    }
    
    private func imageViewsCommonConfig(_ imageView: UIImageView) {
        imageView.backgroundColor = UIColor.white
        let mode = dataSource?.loopView(contentModeFor: self)
        imageView.contentMode = mode ?? .scaleToFill
    }
    
    /// 设置初始图片
    fileprivate func setOrigins() {
        let sourceCount = source.count
        if sourceCount == 0 {
            scroll.isScrollEnabled = false
        } else if sourceCount == 1 {
            scroll.isScrollEnabled = false
            set(image: cImageView, by: 0)
        } else {
            scroll.isScrollEnabled = true
            startTimer()
            let indexs = prepareIndexs(by: source, centerIndex: &cIndex)
            set(image: lImageView, by: indexs.0)
            set(image: cImageView, by: indexs.1)
            set(image: rImageView, by: indexs.2)
            pageControl.currentPage = cIndex
        }
    }
    
    /// 启动定时器
    private func startTimer() {
        guard let flag = dataSource?.loopView(isAutoLoopFor: self), flag == true else { return }
        if let timer = timer {
            timer.invalidate()
        }
        if let timeInterval = dataSource?.loopView(autoLoopTimeIntervalFor: self) {
            timer = Timer.JREvery(timeInterval, { [weak self] _ in
                let point = CGPoint.init(x: self!.bounds.size.width * 2, y: 0)
                self?.layoutIfNeeded()
                self?.scroll.setContentOffset(point, animated: true)
                self?.perform(#selector(self!.scrollViewDidEndDecelerating), with: self?.scroll, afterDelay: 0.4.JRSeconds)
            })
        }
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - imageView: imageView description
    ///   - index: index description
    private func set(image imageView: UIImageView, by index: Int) {
        func net(url: URL) {
            imageView.sd_setImage(with: url, placeholderImage: dataSource.loopView(placeHolderFor: self))
        }
        
        func local(name: String) {
            imageView.image = UIImage.init(named: name)
        }
        let type = dataSource!.loopView(imagesSourceType: self)
        switch type {
        case .url:
            guard let url = source[index] as? URL else { return }
            net(url: url)
            
        case .urlString:
            guard let urlString = source[index] as? String else { return }
            guard let url = URL.init(string: urlString) else { return }
            net(url: url)
            
        case .name:
            guard let name = source[index] as? String else { return }
            local(name: name)
        }
    }
    
    /// 设置偏移量
    private func setCurrent() {
        let point = CGPoint.init(x: bounds.size.width, y: 0)
        scroll?.setContentOffset(point, animated: false)
    }
    
    /// 获取偏移量
    ///
    /// - Parameters:
    ///   - source: 数据源
    ///   - centerIndex: 中位偏移量
    /// - Returns: 左偏移量、中偏移量、右偏移量
    private func prepareIndexs(by source: [Any], centerIndex: inout Int) -> (Int, Int, Int) {
        let sourceCount = source.count
        if sourceCount == 0 {
            return (0, 0, 0)
        } else if centerIndex == -1 || centerIndex == sourceCount - 1 {
            centerIndex = sourceCount - 1
            return (centerIndex - 1, centerIndex, 0)
        } else if centerIndex == sourceCount || centerIndex == 0 {
            centerIndex = 0
            return (sourceCount - 1, centerIndex, centerIndex + 1)
        } else {
            return (centerIndex - 1, centerIndex, centerIndex + 1)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width > 0 {
            setCurrent()
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

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
    
    static let color = UIColor.clear
    
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
        guard let dataSource = dataSource else { return [] }
        switch dataSource.loopView(imagesSourceType: self) {
        case .url:
            let urls = dataSource.loopView(imagesURLFor: self)
            return urls
            
        case .urlString:
            let urlStrings = dataSource.loopView(imagesURLStringFor: self)
            return urlStrings
            
        case .name:
            let names = dataSource.loopView(imagesNameFor: self)
            return names
            
        case .image:
            let images = dataSource.loopView(imagesFor: self)
            return images
        }
    }
    
    public func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setDefaultCurrentPage()
            strongSelf.pageControlConfig()
            strongSelf.setOrigins()
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            do {
                strongSelf.scroll = UIScrollView()
                strongSelf.scroll.backgroundColor = JRLoopView.color
                JRLoopViewConfiguration.JRScrollViewConfiguration(strongSelf.scroll)
                strongSelf.addTapGesture(strongSelf.scroll)
                strongSelf.scroll.delegate = self
                strongSelf.addSubview(strongSelf.scroll)
                strongSelf.scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
            }
            
            do {
                strongSelf.helperView = UIView()
                strongSelf.helperView.backgroundColor = JRLoopView.color
                strongSelf.scroll.addSubview(strongSelf.helperView)
                strongSelf.helperView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                    $0.height.equalToSuperview()
                    $0.width.equalTo(strongSelf).multipliedBy(3)
                }
                
                strongSelf.customImageViews()
            }
        }
    }
    
    private func addTapGesture(_ scrollView: UIScrollView) {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        guard source.count > 0, source.count > cIndex else { return }
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
        imageView.backgroundColor = JRLoopView.color
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
            if timer == nil {
                startTimer()
            }
            let indexs = prepareIndexs(by: source, centerIndex: &cIndex)
            set(image: lImageView, by: indexs.0)
            set(image: cImageView, by: indexs.1)
            set(image: rImageView, by: indexs.2)
            pageControl.currentPage = cIndex
        }
        delegate?.loopView(self, current: cIndex, total: source.count)
    }
    
    /// 启动定时器
    private func startTimer() {
        guard let flag = dataSource?.loopView(isAutoLoopFor: self), flag == true else { return }
        if let timer = timer {
            timer.invalidate()
        }
        if let timeInterval = dataSource?.loopView(autoLoopTimeIntervalFor: self) {
            timer = Timer.JREvery(timeInterval, .global(), { [weak self] _ in
                self?.autoScroll()
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
        
        func loadImage(image: UIImage) {
            imageView.image = image
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
            
        case .image:
            guard let image = source[index] as? UIImage else { return }
            loadImage(image: image)
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
    
    private func autoScroll() {
        let point = CGPoint.init(x: bounds.size.width * 2, y: 0)
        layoutIfNeeded()
        scroll.setContentOffset(point, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            let current = Int(ceil(self.scroll.contentOffset.x / self.bounds.size.width))
            let pointx = CGPoint.init(x: self.bounds.size.width, y: 0)
            self.scroll.setContentOffset(pointx, animated: false)
            self.cIndex += current - 1
            self.setOrigins()
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

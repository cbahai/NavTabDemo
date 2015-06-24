//
//  NavTab.swift
//  NavTabDemo
//
//  Created by 冯勇海 on 15/6/23.
//  Copyright © 2015年 Chai. All rights reserved.
//

import UIKit

// 可选协议只能在含有@objc前缀的协议中生效。且@objc的协议只能被类遵循
@objc protocol NavTabDelegate {
    optional func onTabButtonPressed(index: Int)
}

class NavTab: UIScrollView {
    
    var navTabDelegate: NavTabDelegate?
    let datas: [String]
    var selectedIndex: Int
    let tabWidth: CGFloat  // 固定Tab的宽，屏幕宽点就显示多点
    let indicatorEdge: CGFloat = 8
    var indicator: UIView!
    var tabButtonArr: [UIButton]?
    
    // 拉nib无效
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(datas: [String], selectedIndex: Int, tabWidth: CGFloat, totalWidth: CGFloat, totalHeight: CGFloat) {
        self.datas = datas
        self.selectedIndex = selectedIndex >= datas.count ? datas.count - 1 : selectedIndex
        self.tabWidth = tabWidth
        super.init(frame: CGRectMake(0, 0, totalWidth, totalHeight))
        buildTabs()
        buildIndicator()
        scrollToSelectedIndex()
    }
    
    // 创建选项卡
    private func buildTabs() {
        tabButtonArr = []
        let tabCount = datas.count
        for var i=0; i<tabCount; i++ {
            let tabButton = UIButton(type: .Custom)
            var tabButtonFrame = tabButton.frame
            tabButtonFrame.origin.x = tabWidth * CGFloat(i)
            tabButtonFrame.size.width = tabWidth
            tabButtonFrame.size.height = frame.height
            tabButton.frame = tabButtonFrame
            tabButton.titleLabel?.font = UIFont.systemFontOfSize(12)
            tabButton.setTitle(datas[i], forState: .Normal)
            tabButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            tabButton.setTitleColor(UIColor.redColor(), forState: .Selected)
            tabButton.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            tabButton.addTarget(self, action: Selector("tabButtonPressed:"), forControlEvents: .TouchUpInside)
            tabButton.tag = i
            if selectedIndex == i {
                tabButton.selected = true
            } else {
                tabButton.selected = false
            }
            addSubview(tabButton)
            tabButtonArr?.append(tabButton)
        }
        
        contentSize = CGSizeMake(tabWidth * CGFloat(tabCount), frame.height)
        showsHorizontalScrollIndicator = false
    }
    
    // 创建指示器
    private func buildIndicator() {
        indicator = UIView(frame: CGRectMake(tabWidth * CGFloat(selectedIndex) + indicatorEdge, indicatorEdge, tabWidth - indicatorEdge * 2 , frame.height - indicatorEdge * 2))
        indicator.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        indicator.layer.cornerRadius = 5
        indicator.layer.masksToBounds = true
        addSubview(indicator)
    }
    
    func tabButtonPressed(sender: UIButton) {
        if sender.tag == selectedIndex {
            return
        }
        selectedIndex = sender.tag
        resetTab(animate: true)
        autoScroll()
        navTabDelegate?.onTabButtonPressed?(selectedIndex)
    }
    
    // 有多少个完整显示的Tab
    func displayCount() -> Int {
        let count = frame.width / tabWidth
        return Int(count)
    }
    
    func scrollToSelectedIndex() {
        let tempDisplayCount = displayCount()
        if selectedIndex >= tempDisplayCount {
            let point = CGPointMake(tabWidth * CGFloat(selectedIndex - (tempDisplayCount - 1)), 0)
            setContentOffset(point, animated: false)
        }
    }
    
    func autoScroll() {
        let tempDisplayCount = displayCount()
        // 尝试往后移
        if selectedIndex < datas.count - 1 {
            if tabWidth * CGFloat(selectedIndex) >= contentOffset.x + tabWidth * (CGFloat(tempDisplayCount) - 1) - tabWidth * 0.5 {
                let point = CGPointMake(tabWidth * CGFloat(selectedIndex - (tempDisplayCount - 2)), 0)
                setContentOffset(point, animated: true)
            }
        }
        // 尝试往前移
        if selectedIndex > 0 {
            if tabWidth * CGFloat(selectedIndex) <= contentOffset.x + tabWidth * 0.5 {
                let point = CGPointMake(tabWidth * CGFloat(selectedIndex - 1), 0)
                setContentOffset(point, animated: true)
            }
        }
    }
    
    func resetTab(animate animate: Bool) {
        resetTabIndicator(animate)
        resetTabButton()
    }
    
    func resetTabIndicator(animate: Bool) {
        var frame = indicator.frame
        frame.origin.x = tabWidth * CGFloat(selectedIndex) + indicatorEdge
        if animate {
            UIView.animateWithDuration(0.1) { () -> Void in
                self.indicator.frame = frame
            }
        } else {
            indicator.frame = frame
        }
    }
    
    func resetTabButton() {
        if let tempTabsButtonArr = tabButtonArr {
            for tabButton in tempTabsButtonArr {
                if tabButton.tag == selectedIndex {
                    tabButton.selected = true
                    tabButton.titleLabel?.font = UIFont.systemFontOfSize(13)
                } else {
                    tabButton.selected = false
                    tabButton.titleLabel?.font = UIFont.systemFontOfSize(12)
                }
            }
        }
    }
}

//
//  ViewController.swift
//  NavTabDemo
//
//  Created by 冯勇海 on 15/6/23.
//  Copyright © 2015年 Chai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NavTabDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabNames = ["hhiiu", "dddiui", "fffiig", "ddfddd", "ffdsffg", "dfdsfsdd", "ffffdsfg", "dddfsdf", "fffdsfdsfg", "ddfdsfd", "fffdsfsfg"]
        let navTab = NavTab(datas: tabNames, selectedIndex: 5, tabWidth: 70, totalWidth: view.frame.width, totalHeight: 40)
        navTab.navTabDelegate = self
        
        var navTabFrame = navTab.frame
        navTabFrame.origin.y = 100
        navTab.frame = navTabFrame
        self.view.addSubview(navTab)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NavTabDelegate
    func onTabButtonPressed(index: Int) {
        print("点击了第" + String(index + 1) + "个")
    }
    
}


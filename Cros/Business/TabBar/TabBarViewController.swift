//
//  TabBarViewController.swift
//  eReader
//
//  Created by owen on 2018/7/23.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let firstVC = UINavigationController(rootViewController: HomeViewController())
        let secondVC = UINavigationController(rootViewController: MineralViewController())
        let thirdVC = UINavigationController(rootViewController: NewsViewController())
        let fourthVC = UINavigationController(rootViewController: MineralViewController())
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        firstVC.tabBarItem = UITabBarItem(title: "资产", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        secondVC.tabBarItem = UITabBarItem(title: "挖矿", image: #imageLiteral(resourceName: "mineral"), selectedImage: #imageLiteral(resourceName: "mineral_selected"))
        thirdVC.tabBarItem = UITabBarItem(title: "资讯", image: #imageLiteral(resourceName: "news"), selectedImage: #imageLiteral(resourceName: "news_selected"))
        fourthVC.tabBarItem = UITabBarItem(title: "我的", image: #imageLiteral(resourceName: "mine"), selectedImage: #imageLiteral(resourceName: "mine_selected"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

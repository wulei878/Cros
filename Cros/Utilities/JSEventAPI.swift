//
//  JSAPITest.swift
//  Cros
//
//  Created by owen on 2018/8/8.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation

class JSEventAPI: NSObject {
    @objc func getToken(arg: String) -> String {
        return UserInfo.shard.token
    }

    @objc func getUUID(arg: String) -> String {
        if let key = CRORequest.shard.privateKey {
            return key
        }
        return ""
    }

    @objc func goActivity(arg: String) {
        if arg == "exit_login" {
            UserInfo.shard.clear()
        } else if arg == "login" {
            guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
                let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController
            else { return }
            navi.viewControllers[0].present(UINavigationController(rootViewController: PhoneLoginViewController()), animated: true, completion: nil)
        }
    }
    @objc func share(arg: String, handler: (String, Bool) -> Void) {
        handler("succeed", true)
    }
    @objc func copyString(arg: String) -> String {
        return ""
    }
    @objc func getVersionName(arg: String) -> String {
        return ""
    }
    @objc func pickPic(arg: String, handler: (String, Bool) -> Void) {
        handler("succeed", true)
    }
    @objc func hideMenuBar(arg: String) {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return }
        tabbar.tabBar.isHidden = true
    }
    @objc func showMenuBar(arg: String) {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return }
        tabbar.tabBar.isHidden = false
    }
}

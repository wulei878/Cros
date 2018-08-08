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
            NotificationCenter.default.post(name: kLogoutSucceedNotification, object: nil)
        } else if arg == "login" {
            guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
                let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController
            else { return }
            let count = navi.viewControllers.count
            navi.viewControllers[count - 1].present(UINavigationController(rootViewController: PhoneLoginViewController()), animated: true, completion: nil)
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
    @objc func pickPic(arg: String, handler: @escaping (String, Bool) -> Void) {
        //从相册中选择图片
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.photoLibrary
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController,
            let currentVC = navi.viewControllers[navi.viewControllers.count - 1] as? MineViewController
            else { return }
        picture.delegate = currentVC
        currentVC.getHeaderImageHandle = handler
        currentVC.present(picture, animated: true, completion: nil)
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

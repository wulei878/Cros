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

    @objc func goActivity(arg: String) -> String {
        if arg == "exit_login" {
            UserInfo.shard.clear()
            NotificationCenter.default.post(name: kLogoutSucceedNotification, object: nil)
        } else if arg == "login" {
            guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
                let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController
            else { return "" }
            let count = navi.viewControllers.count
            navi.viewControllers[count - 1].present(UINavigationController(rootViewController: PhoneLoginViewController()), animated: true, completion: nil)
        }
        return ""
    }
    @objc func share(arg: String, handler: @escaping (String, Bool) -> Void) {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController
            else { return }
        let count = navi.viewControllers.count
        UMSocialUIManager.showShareMenuViewInWindow { (type, _) in
            ShareManager.shareImageOrText(vc: navi.viewControllers[count - 1], platformType: type, message: "棒极了", image: nil, thumbImage: nil, completion: { (result, _) in
                print(result ?? "")
                handler("succeed", true)
            })
        }
    }
    @objc func getVersionCode(arg: String) -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
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
    @objc func hideMenuBar(arg: String) -> String {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return "" }
        tabbar.tabBar.isHidden = true
        return ""
    }
    @objc func showMenuBar(arg: String) -> String {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return "" }
        tabbar.tabBar.isHidden = false
        return ""
    }
    @objc func fetchAssetInfo(arg: String, handler: @escaping ([String: Any], Bool) -> Void) {
        handler(WebViewController.shard.param ?? [String: Any](), true)
    }
    @objc func fetchWalletAddress(arg: String, handler: @escaping ([String: Any], Bool) -> Void) {
        handler(WebViewController.shard.param ?? [String: Any](), true)
    }
    @objc func changeTabBar(arg: String) -> String {
        guard let tabbar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
            let navi = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController,
            let _ = navi.viewControllers[0] as? HomeViewController
            else { return "" }
        navi.popToRootViewController(animated: true)
        return ""
    }
}

class ShareManager {
    class func shareImageOrText(vc: UIViewController,
                          platformType: UMSocialPlatformType,
                          message: String?,
                          image: String?,
                          thumbImage: String?,
                          completion: ((Any?, NSError?) -> Void)?) {
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //设置文本
        if let message = message {
            messageObject.text = message
        }

        if let image = image {
            //创建图片内容对象
            let shareObject = UMShareImageObject()
            shareObject.shareImage = image
            //如果有缩略图，则设置缩略图
            if let thumbImage = thumbImage {
                shareObject.thumbImage = UIImage(named: thumbImage)
            }
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject
        }

        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
            completion?(data, error as NSError?)
        }
    }
}

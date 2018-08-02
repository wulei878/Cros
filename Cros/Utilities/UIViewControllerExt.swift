//
//  UIViewControllerExt.swift
//  Cros
//
//  Created by Owen on 2018/8/2.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

extension UIViewController {
    var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                return window?.safeAreaInsets ?? .zero
            }
            return .zero
        }
    }

    func addBackBtn() {
        let backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.contentHorizontalAlignment = .left
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backBtn)]
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

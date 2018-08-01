//
//  HUD.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import MBProgressHUD

public enum HUDStyle {
    case normal
    case successful
    case failed
}

open class HUD {
    // MARK: - HUD
    @discardableResult
    public class func progress(in view: UIView) -> MBProgressHUD {
        let hud: MBProgressHUD = MBProgressHUD(view: view)
        view.addSubview(hud)
        hud.removeFromSuperViewOnHide = true

        return hud
    }

    @discardableResult
    public class func showText(_ text: String, in view: UIView, hideDelay: TimeInterval = 2) -> MBProgressHUD {
        func createHUD() -> MBProgressHUD {
            let hud = self.progress(in: view)

            hud.mode = .text
            hud.margin = 20
            hud.minSize = CGSize(width: 120, height: 30)

            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            hud.contentColor = UIColor(white: 1, alpha: 1)

            hud.label.text = text
            hud.label.font = UIFont.systemFont(ofSize: 17)

            hud.bezelView.center = hud.superview!.center
            hud.layoutIfNeeded()

            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: hideDelay)
            return hud
        }
        var hud: MBProgressHUD?
        // 弱网情况下会有不在主线程的情况
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                hud = createHUD()
            }
        } else {
            hud = createHUD()
        }
        return hud!
    }

    @discardableResult
    public class func showTextInWindowCenter(
        _ text: String,
        duration: TimeInterval = 2,
        for hudStyle: HUDStyle = .normal) -> MBProgressHUD? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }

        let hud: MBProgressHUD = self.progress(in: window)
        hud.margin = 15
        hud.contentColor = UIColor.white

        switch hudStyle {
        case .normal:
            hud.mode = .text
        case .successful:
            hud.mode = .customView
//            hud.customView = UIImageView(image: Resources.toast_success_icon)
        case .failed:
            hud.mode = .customView
//            hud.customView = UIImageView(image: Resources.toast_failed_icon)
        }

        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(white: 0, alpha: 0.8)

        hud.label.numberOfLines = 0
        hud.label.text = text
        hud.label.font = UIFont.systemFont(ofSize: 17)

        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: duration)

        return hud
    }

    @discardableResult
    public class func showActivityIndicatior(_ title: String, in view: UIView) -> MBProgressHUD {
        let hud: MBProgressHUD = self.progress(in: view)

        hud.mode = .indeterminate
        hud.margin = 8
        hud.minSize = CGSize(width: 120, height: 120)

        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        hud.label.text = title
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.contentColor = UIColor(white: 1, alpha: 1)

        hud.layoutIfNeeded()
        hud.frame.origin.y += 10

        hud.show(animated: true)

        return hud
    }

    @discardableResult
    public class func showActivityIndicatiorInWindowCenter(_ title: String) -> MBProgressHUD? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        let hud: MBProgressHUD = self.progress(in: window)

        hud.mode = .indeterminate
        hud.margin = 8
        hud.minSize = CGSize(width: 120, height: 120)

        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        hud.label.text = title
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.contentColor = UIColor(white: 1, alpha: 1)

        hud.layoutIfNeeded()
        hud.frame.origin.y += 10

        hud.show(animated: true)
        return hud
    }

    public class func hide(_ hud: MBProgressHUD, animated: Bool = true) {
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: animated)
    }
}

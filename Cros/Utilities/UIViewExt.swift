//
//  UIViewExt.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

extension UIView {
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
}

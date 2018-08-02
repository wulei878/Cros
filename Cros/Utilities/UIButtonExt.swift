//
//  UIButtonExt.swift
//  Cros
//
//  Created by Owen on 2018/8/2.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControlState) {
        guard let realColor = color else { return }
        setBackgroundImage(UIImage(color: realColor), for: state)
    }
}

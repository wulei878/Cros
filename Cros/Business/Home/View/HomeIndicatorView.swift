//
//  HomeIndicatorView.swift
//  Cros
//
//  Created by Owen on 2018/8/4.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class HomeIndicatorView: UIView {
    var indicatorCount = 0 {
        didSet {
            var preView: UIView!
            for i in 0..<indicatorCount {
                let view = Indicator()
                addSubview(view)
                if i == 0 {
                    view.snp.makeConstraints { (make) in
                        make.left.equalTo(0)
                    }
                } else if i == indicatorCount - 1 {
                    view.snp.makeConstraints { (make) in
                        make.right.equalTo(0)
                    }
                }
                view.snp.makeConstraints { (make) in
                    make.width.equalTo(20)
                    make.height.equalTo(2)
                    make.top.bottom.equalTo(0)
                    if i > 0 {
                        make.left.equalTo(preView.snp.right).offset(4)
                    }
                }
                preView = view
                indicators.append(view)
            }
        }
    }

    private var indicators = [Indicator]()

    var currenIndex = 0 {
        didSet {
            guard currenIndex < indicators.count else { return }
            for (index, view) in indicators.enumerated() {
                view.isSelected = index == currenIndex
            }
        }
    }

    private class Indicator: UIView {
        var isSelected = false {
            didSet {
                backgroundColor = isSelected ? UIColor(rgb: 0x4a9eff) : UIColor(rgb: 0x4a9eff, a: 0.3)
            }
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor(rgb: 0x4a9eff, a: 0.3)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}

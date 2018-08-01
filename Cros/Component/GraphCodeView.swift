//
//  GraphCodeView.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class GraphCodeView: UIView {
    var codeStr = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 210, green: 210, blue: 210)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let text = codeStr
        let cSize = "A".size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)])
        let width = rect.size.width / CGFloat(text.count) - cSize.width
        let height = rect.size.height - cSize.height
        var point = CGPoint.zero
        var pX:CGFloat = 0
        var pY:CGFloat = 0
        for (index,character) in text.enumerated() {
            pX = CGFloat(arc4random()).truncatingRemainder(dividingBy: width) + rect.size.width / CGFloat(text.count * index)
            pY = CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
            point = CGPoint(x: pX, y: pY)
        }
    }
}

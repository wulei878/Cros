//
//  UIImageExt.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    func cropSquareImage(width: CGFloat) -> UIImage {
        let imageWidth = size.width * scale
        let imageHeight = size.height * scale
        let offsetX = (imageWidth - width) / 2
        let offsetY = (imageHeight - width) / 2
        let rect = CGRect(x: offsetX, y: offsetY, width: width, height: width)
        guard let newImageRef = cgImage?.cropping(to: rect) else {
            return self
        }
        let newImage = UIImage(cgImage: newImageRef)
        return newImage
    }
}

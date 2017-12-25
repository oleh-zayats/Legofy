//
//  UIImage+Resizing.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/25/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Resizes UIImage to fit given width preserving it's ratio
     - parameter width: width the image should fit
     - returns: resized UIImage (optional)
     */
    func resize(toFit width: CGFloat) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        let scaleFactor = width / size.width
        let newHeight = size.height * scaleFactor
        let ctxSize = CGSize(width: width, height: newHeight)
        UIGraphicsBeginImageContext(ctxSize)
        let rect = CGRect(x: 0, y: 0, width: width, height: newHeight)
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

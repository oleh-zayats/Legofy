//
//  UIImage+Extensions.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

extension UIImage {
    
    func averageColor() -> UIColor {
        
        let rawImageRef: CGImage = cgImage!
        let data: CFData = rawImageRef.dataProvider!.data!
        let rawPixelData = CFDataGetBytePtr(data)
        
        let imageHeight = rawImageRef.height
        let imageWidth  = rawImageRef.width
        
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 4
        
        var r = 0
        var g = 0
        var b = 0
        
        for row in 0...imageHeight {
            
            var rowPtr = rawPixelData! + bytesPerRow * row
            
            for _ in 0...imageWidth {
                r += Int(rowPtr[0])
                g += Int(rowPtr[1])
                b += Int(rowPtr[2])
                rowPtr += Int(stride)
            }
        }
        
        let f: CGFloat = 1.0 / (255.0 * CGFloat(imageWidth) * CGFloat(imageHeight))
        
        return UIColor(red:   f * CGFloat(r),
                       green: f * CGFloat(g),
                       blue:  f * CGFloat(b),
                       alpha: 1.0)
    }

    func filled(with color: UIColor) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let context = UIGraphicsGetCurrentContext()!

        context.setBlendMode(.multiply)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        color.setFill()

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        context.draw(cgImage!, in: rect)
        context.addRect(rect)
        context.drawPath(using: .fill)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

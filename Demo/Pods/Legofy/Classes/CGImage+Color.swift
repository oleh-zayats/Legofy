//
//  CGImage+Color.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

extension CGImage {
    /**
     Analizes CGImage, finds the dominant color
     - returns: UIColor (optional)
     */
    func averageColor() -> UIColor? {
        guard let data: CFData = dataProvider?.data else {
            return nil
        }
        
        guard let rawPixelData = CFDataGetBytePtr(data) else {
            return nil
        }
    
        let stride = bitsPerPixel / 4
        
        var r = 0
        var g = 0
        var b = 0
        
        for row in 0..<height {
            
            var rowPtr = rawPixelData + bytesPerRow * row
            
            for _ in 0...width {
                
                r += Int(rowPtr[2])
                g += Int(rowPtr[1])
                b += Int(rowPtr[0])
                
                rowPtr += Int(stride)
            }
        }
        
        let f: CGFloat = 1.0 / (255.0 * CGFloat(width) * CGFloat(height))
        
        return UIColor(red: f * CGFloat(r),
                     green: f * CGFloat(g),
                      blue: f * CGFloat(b),
                     alpha: 1.0)
    }
    
    /**
     Fills CGImage with given color and returns a new UIImage
     - parameter color: image color
     - returns: colored UIImage
     */
    func filled(with color: UIColor) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setBlendMode(.multiply)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1.0, y: -1.0)
        
        color.setFill()
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        context.draw(self, in: rect)
        context.addRect(rect)
        context.drawPath(using: .fill)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

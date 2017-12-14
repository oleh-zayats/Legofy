//
//  Utility.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/14/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

func measure(_ operationName: String, operation: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("\(operationName) DONE in: \(timeElapsed) s")
}

func resize(_ image: UIImage, toFit width: CGFloat) -> UIImage {
    defer {
        UIGraphicsEndImageContext()
    }
    let scaleFactor = width / image.size.width
    let newHeight = image.size.height * scaleFactor
    let ctxSize = CGSize(width: width, height: newHeight)
    UIGraphicsBeginImageContext(ctxSize)
    let rect = CGRect(x: 0, y: 0, width: width, height: newHeight)
    image.draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext()!
}

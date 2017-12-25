//
//  Utility.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/14/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

/**
 Prints out time spent to perform a chunk of code. For testing.
 - parameter operationName: given function/chunk of code name
 - parameter operation: closure in which code is passed to measure the performance
 */
func measure(_ operationName: String, operation: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("\(operationName) DONE in: \(timeElapsed) s")
}

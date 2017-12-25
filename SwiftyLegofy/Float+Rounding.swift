//
//  Float+Rounding.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/25/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import Foundation

extension Float {
    /**
     Rounds value (ex.: 0.0234551 -> func called with param "2" -> 0.02)
     - parameter places: digits count that's left after rounding
     - returns: Float
     */
    mutating func roundTo(_ places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return Darwin.round(self * divisor) / divisor
    }
}

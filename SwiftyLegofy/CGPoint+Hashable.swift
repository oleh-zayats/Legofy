//
//  CGPoint+Hashable.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/15/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit


extension CGPoint: Hashable {
    
    // https://stackoverflow.com/questions/32988665/is-there-a-specific-way-to-use-tuples-as-set-elements-in-swift

    public var hashValue: Int {
        return (x.hashValue << MemoryLayout<CGFloat>.size) ^ y.hashValue
    }
}

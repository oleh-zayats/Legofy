//
//  LegofyServiceProtocol.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/26/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

protocol LegofyServiceProtocol {
    
    var delegate: LegofyServiceDelegate? { get set }
    var isPercentProgressEnabled: Bool   { get set }
    
    func generateImage()
    func generateBrickTileImages()
    func setOutputSize(_ size: CGSize)
    func setBrickSize(_ size: CGFloat)
    
}

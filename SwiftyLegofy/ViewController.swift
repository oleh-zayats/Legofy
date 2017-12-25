//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sourceImage = #imageLiteral(resourceName: "source5")
    var legofyService: LegofyProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        legofyService = LegofyService(sourceImage: sourceImage, frame: view.bounds, brickSize: 10.0)
        
        addLegofiedImageSubview()
    }
    
    /* 1. Generate a legofied UIImage
     */
    func addLegofiedImageSubview() {
        if let legofiedImage = legofyService?.generateLegofiedImage() {
            let legofiedImageView = UIImageView(image: legofiedImage)
            view.addSubview(legofiedImageView)
        }
    }
    
    /* 2. or generate brick tiles and do whatever you like (adding as subviews here) :P
     */
    func addLegofiedTileSubviews() {
        legofyService?
            .generateLegofiedTiles()
            .forEach { (position, image) in
                let tileImageView = UIImageView(frame: CGRect(origin: position, size: image.size))
                tileImageView.image = image
                view.addSubview(tileImageView)
        }
    }
}

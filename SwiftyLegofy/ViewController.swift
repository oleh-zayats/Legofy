//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var legofyService: LegofyServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        legofyService = LegofyService(sourceImage: #imageLiteral(resourceName: "source5"), outputSize: view.bounds.size, brickSize: 15.0)
        legofyService?.delegate = self
        legofyService?.isPercentProgressEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        legofyService?.setOutputSize(size)
    }
    
    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
        let brickSize = floor(CGFloat(sender.value))
        print("Brick Size: \(brickSize)")
        legofyService?.setBrickSize(brickSize)
    }
    
    @IBAction func legofyButtonDidTouchUpInside(_ sender: UIButton) {
        cleanup()
        legofyService?.generateImage()
    }
    
    @IBAction func cleanButtonDidTouchUpInside(_ sender: UIButton) {
        cleanup()
    }
}

extension ViewController: LegofyServiceDelegate {
    func legofyServiceDidUpdateProgress(_ progress: Float) {
        print("\(progress)%")
    }
    
    func legofyServiceDidFinishGeneratingImage(_ image: UIImage) {
        addImageSubview(image)
    }
    
    func legofyServiceDidFinishGeneratingTileImages(_ positionsAndTiles: [CGPoint: UIImage]) {
        addTilesSubviews(positionsAndTiles)
    }
}

private extension ViewController {
    func addImageSubview(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    func addTilesSubviews(_ positionsAndTiles: [CGPoint: UIImage]) {
        positionsAndTiles.forEach { (position, image) in
            let frame = CGRect(origin: position, size: image.size)
            let tileImageView = UIImageView(frame: frame)
            tileImageView.image = image
            view.addSubview(tileImageView)
            view.sendSubview(toBack: tileImageView)
        }
    }
    
    func cleanup() {
        view.subviews.forEach { subview in
            if (subview is UIButton) == false
            && (subview is UISlider) == false {
                subview.removeFromSuperview()
            }
        }
    }
}

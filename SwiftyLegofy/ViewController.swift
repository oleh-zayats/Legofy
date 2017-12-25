//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var legofyService: LegofyProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        legofyService = LegofyService(sourceImage: #imageLiteral(resourceName: "source5"), outputSize: view.bounds.size, brickSize: 15.0)
        legofyService?.delegate = self
        legofyService?.isPercentValueProgressEnabled = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        legofyService?.setOutputSize(size)
    }
    
    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
        let size = floor(CGFloat(sender.value))
        print("Brick Size: \(size)")
        legofyService?.setBrickSize(size)
    }
    
    @IBAction func legofyButtonDidTouchUpInside(_ sender: UIButton) {
        cleanView()
        legofyService?.generateImage()
    }
    
    @IBAction func cleanButtonDidTouchUpInside(_ sender: UIButton) {
        cleanView()
    }
}

extension ViewController: LegofyServiceDelegate {
    func legofyServiceDidUpdateProgress(progress: Float) {
        print("\(progress)%")
    }
    
    func legofyServiceDidRenderImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    func legofyServiceDidGenerateTiles(positionsAndTiles: [CGPoint: UIImage]) {
        positionsAndTiles.forEach { (position, image) in
            let tileImageView = UIImageView(frame: CGRect(origin: position, size: image.size))
            tileImageView.image = image
            view.addSubview(tileImageView)
            view.sendSubview(toBack: tileImageView)
        }
    }
}

private extension ViewController {
    func cleanView() {
        view.subviews.forEach { subview in
            if (subview is UIButton) == false && (subview is UISlider) == false {
                subview.removeFromSuperview()
            }
        }
    }
}

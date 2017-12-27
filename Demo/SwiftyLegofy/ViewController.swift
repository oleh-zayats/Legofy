//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit
import Legofy

private enum Default {
    static let brickSize: CGFloat = 50.0
    static let sourceImg: UIImage = #imageLiteral(resourceName: "source-image")
    static let brickType: BrickType = .clean
}

class ViewController: UIViewController {

    @IBOutlet weak var sliderControl: UISlider!
    @IBOutlet weak var outputImageView: UIImageView!
    @IBOutlet weak var brickSizeLabel: UILabel!
    
    var legofyService: LegofyServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        /* Setup Legofy service */
        
        legofyService = LegofyService(sourceImage: Default.sourceImg,
                                        brickSize: Default.brickSize,
                                        brickType: Default.brickType)
        legofyService?.delegate = self
        legofyService?.isPercentProgressEnabled = true
    }
}

// MARK: - LegofyServiceDelegate

extension ViewController: LegofyServiceDelegate {
    func legofyServiceDidUpdateProgress(_ progress: Float) {
        print("\(progress)%")
    }
    
    func legofyServiceDidFinishGeneratingImage(_ image: UIImage) {
        outputImageView.image = image
    }
    
    func legofyServiceDidFinishGeneratingTileImages(_ positionsAndTiles: [CGPoint: UIImage]) {
        print("Generated \(positionsAndTiles.count) tiles")
    }
}

// MARK: - Actions

private extension ViewController {
    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
        let brickSize = floor(CGFloat(sender.value))
        brickSizeLabel.text = "Brick Size: \(brickSize)"
        legofyService?.setBrickSize(brickSize)
    }
    
    @IBAction func segmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            legofyService?.setBrickType(.clean)
        } else if index == 1 {
            legofyService?.setBrickType(.legoV1)
        } else if index == 2 {
            legofyService?.setBrickType(.legoV2)
        } else if index == 3 {
            legofyService?.setBrickType(.legoV3)
        }
    }
    
    @IBAction func legofyButtonDidTouchUpInside(_ sender: UIButton) {
        legofyService?.generateImage()
    }
    
    @IBAction func cleanButtonDidTouchUpInside(_ sender: UIButton) {
        outputImageView.image = Default.sourceImg
    }
}

// MARK: - Initial Setup

private extension ViewController {
    func initialSetup() {
        outputImageView.layer.borderWidth = 3.0
        outputImageView.layer.borderColor = UIColor.darkGray.cgColor
        brickSizeLabel.text = "Brick Size: \(Default.brickSize)"
        sliderControl.value = Float(Default.brickSize)
    }
}

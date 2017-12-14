//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let brick = #imageLiteral(resourceName: "lego-brick-tile-bw")
    
    private lazy var sourceImage: UIImage = {
        var img = UIImage()
        measure("Resizing source image") { img = resize(#imageLiteral(resourceName: "source5"), toFit: view.bounds.width) }
        return img
    }()
    
    private var brickImageViews = [IndexPath: UIImageView]()
    private var positions = [IndexPath: CGPoint]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measure("\n") {
            legofy(image: sourceImage, brickSize: 30.0, directory: NSTemporaryDirectory())
        }
    }
    
    func legofy(image: UIImage, brickSize: CGFloat, directory: String) {
        
        measure("Cleaning temporary directory") {
            self.cleanup()
        }
        
        let tileSize = CGSize(width: brickSize,
                              height: brickSize)
        
        measure("Slicing source image") {
            self.slice(image: image,
                       sliceSize: tileSize,
                       directory: directory,
                       completion: { positions in
                        self.positions = positions
            })
        }
        
        measure("Placing bricks") {
            self.positions.forEach { position in
                self.addBrickImage(brick, indexPath: position.key, size: tileSize)
            }
        }
        
        var colors = [IndexPath: UIColor]()
        measure("Picking dominant colors") {
            colors = self.pickDominantColors(forImagesIn: directory)
        }
        
        measure("Rendering color bricks") {
            self.brickImageViews.forEach { (indexPath, imageView) in
                if let dominantColor = colors[indexPath]{
                    imageView.image = imageView.image?.filled(with: dominantColor)
                }
            }
        }
    }
    
    func pickDominantColors(forImagesIn directory: String) -> [IndexPath: UIColor] {
        var dominantColors = [IndexPath: UIColor]()
        do {
            let fileManager = FileManager.default
            let itemPaths = try fileManager.contentsOfDirectory(atPath: directory)
            for path in itemPaths.sorted() {
                if let image = UIImage(contentsOfFile: "\(directory)\(path)") {
                    let color = image.averageColor()
                    if  let row = Int(path.split(separator: ".")[1]),
                        let col = Int(path.split(separator: ".")[0]) {
                        let indexPath = IndexPath(row: row, section: col)
                        dominantColors[indexPath] = color
                    }
                }
            }
        } catch let error {
            print(error)
        }
        return dominantColors
    }
    
    func addBrickImage(_ image: UIImage, indexPath: IndexPath, size: CGSize) {
        guard let point = positions[indexPath] else {
            return
        }
        let image = resize(image, toFit: size.width)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: point.x, y: point.y), size: size)
        brickImageViews[indexPath] = imageView
        
        view.addSubview(imageView)
    }
    
    func slice(image: UIImage, sliceSize: CGSize, directory: String, completion: ([IndexPath: CGPoint]) -> Void) {
        
        let columns: CGFloat = image.size.width / sliceSize.width
        let rows:    CGFloat = image.size.height / sliceSize.height
        
        var completeColumns: Int = Int(floorf(Float(columns)))
        var completeRows:    Int = Int(floorf(Float(rows)))
        
        let widthRemainer:  CGFloat = image.size.width  - (CGFloat(completeColumns) * sliceSize.width)
        let heightRemainer: CGFloat = image.size.height - (CGFloat(completeRows)    * sliceSize.height)
        
        if columns > CGFloat(completeColumns) { completeColumns += 1 }
        if rows    > CGFloat(completeRows)    { completeRows += 1 }
        
        var positions = [IndexPath: CGPoint]()
        for row in 0..<completeRows {
            
            for column in 0..<completeColumns {
                
                var tempSliceSize: CGSize = sliceSize
                
                if column + 1 == completeColumns && widthRemainer > 0 {
                    tempSliceSize.width = widthRemainer
                }
                
                if row + 1 == completeRows && heightRemainer > 0 {
                    tempSliceSize.height = heightRemainer
                }
                
                let indexPath = IndexPath(row: row, section: column)
                let position  = CGPoint(x: CGFloat(column) * sliceSize.width,
                                        y: CGFloat(row) * sliceSize.height)
                
                positions[indexPath] = position
                
                let cropArea = CGRect(x: position.x,
                                      y: position.y,
                                      width: tempSliceSize.width,
                                      height: tempSliceSize.height)
                
                if let tileImage: CGImage = image.cgImage?.cropping(to: cropArea) {
                    
                    let slicePath = "\(directory)/\(column).\(row).png"
                    let imageSliceSaveURL = URL(fileURLWithPath: slicePath, isDirectory: false)
                    
                    do {
                        let slice = UIImage(cgImage: tileImage)
                        try UIImagePNGRepresentation(slice)?.write(to: imageSliceSaveURL, options: .atomic)
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
        
        completion(positions)
    }
    
    func cleanup() {
        FileManager.cleanTemporaryDirectory()
    }
}

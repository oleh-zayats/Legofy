//
//  ViewController.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/13/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let brickSourceImage = #imageLiteral(resourceName: "lego-brick-tile-bw")
    private let sourceImage = #imageLiteral(resourceName: "source5")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measure("All operations") {
            let image = resize(sourceImage, toFit: view.bounds.width)
            legofy(image: image, brickSize: 30.0)
        }
    }
}

private extension ViewController {

    func legofy(image: UIImage, brickSize: CGFloat) {

        let size = CGSize(width: brickSize, height: brickSize)
        calculateTilePositionsAndColors(image: image, tileSize: size).forEach { (position, color) in
            self.addBrickImage(brickSourceImage, position: position, color: color, size: size)
        }
    }
    
    func addBrickImage(_ brickImage: UIImage, position: CGPoint, color: UIColor, size: CGSize) {
        let image = resize(brickImage, toFit: size.width).cgImage?.filled(with: color)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: position.x, y: position.y), size: size)
        view.addSubview(imageView)
    }
    
    func calculateTilePositionsAndColors(image: UIImage, tileSize: CGSize) -> [CGPoint: UIColor] {
        
        var result = [CGPoint: UIColor]()
        let grid = calculateColumnsAndRows(for: image, withTileSize: tileSize)
        
        let remainerW: CGFloat = image.size.width  - (CGFloat(grid.columns) * tileSize.width)
        let remainerH: CGFloat = image.size.height - (CGFloat(grid.rows)    * tileSize.height)
        
        for row in 0..<grid.rows {
            
            for column in 0..<grid.columns {
                
                var cropAreaSize: CGSize = tileSize
                
                if column + 1 == grid.columns && remainerW > 0 {
                    cropAreaSize.width = remainerW
                }
                
                if row + 1 == grid.rows && remainerH > 0 {
                    cropAreaSize.height = remainerH
                }

                let position = CGPoint(x: CGFloat(column) * tileSize.width, y: CGFloat(row) * tileSize.height)
                let cropArea = CGRect(x: position.x, y: position.y, width: cropAreaSize.width, height: cropAreaSize.height)
                
                if let tileImage: CGImage = image.cgImage?.cropping(to: cropArea) {
                    result[position] = tileImage.averageColor()
                }
            }
        }
        
        return result
    }
    
    func calculateColumnsAndRows(for image: UIImage, withTileSize tileSize: CGSize) -> (rows: Int, columns: Int) {
        
        let columns: CGFloat = image.size.width / tileSize.width
        let rows:    CGFloat = image.size.height / tileSize.height
        
        var completeColumns: Int = Int(floorf(Float(columns)))
        var completeRows:    Int = Int(floorf(Float(rows)))
        
        if columns > CGFloat(completeColumns) { completeColumns += 1 }
        if rows    > CGFloat(completeRows)    { completeRows += 1 }
        
        return (rows: completeRows, columns: completeColumns)
    }
}

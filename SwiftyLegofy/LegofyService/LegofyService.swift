//
//  LegofyService.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/25/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

protocol LegofyDelegate {
    func legofyServiceDidUpdateProgress(progress: Double)
}

protocol LegofyProtocol {
    func generateLegofiedImage() -> UIImage
    func generateLegofiedTiles() -> [CGPoint: UIImage]
}

final class LegofyService: LegofyProtocol {
    
    private let sourceBrickImage = #imageLiteral(resourceName: "lego-brick-tile-bw")
    private let resizedBrickImage: UIImage
    private let sourceImage: UIImage
    private let hostFrame: CGRect
    private let tileSize: CGSize
    
    init(sourceImage: UIImage, frame: CGRect, brickSize: CGFloat) {
        self.sourceImage = sourceImage.resize(toFit: frame.width)!
        self.tileSize = CGSize(width: brickSize, height: brickSize)
        self.resizedBrickImage = sourceBrickImage.resize(toFit: brickSize)!
        self.hostFrame = frame
    }
    
    /*
     * 1. Calculating columns and rows count in order to produce tiles
     * 2. Calculating dominant colors and positions for tiles
     * 3. Assembling images and positions in dictionary
     */
    func generateLegofiedTiles() -> [CGPoint: UIImage] {
        var positionsAndTiles: [CGPoint: UIImage] = [:]
        
        measure("Legofied tiles generation") {
            calculateTilePositionsAndColors(image: sourceImage, tileSize: tileSize).forEach { (position, color) in
                positionsAndTiles[position] = resizedBrickImage.cgImage?.filled(with: color)
            }
        }
        
        return positionsAndTiles
    }
    
    /*
     * 1. Generating the future legofied image (blank)
     * 2. Calculating dominant colors and positions for tiles to be rendered in an image
     * 3. Initializing graphics renderer for creating Core Graphics-backed image
     * 4. Render tiles and return a UIImage
     */
    func generateLegofiedImage() -> UIImage {
        var image = UIImage()
        
        measure("Legofied UIImage generation") {
            let positionsAndColors = calculateTilePositionsAndColors(image: sourceImage, tileSize: tileSize)
            image = renderImage(with: positionsAndColors)
        }
        
        return image
    }
}

private extension LegofyService {
    func renderImage(with positionsAndColors: [CGPoint: UIColor]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: hostFrame.size, format: .default())
        let image: UIImage = renderer.image { (context) in
            UIColor.white.setFill()
            context.fill(hostFrame)
            positionsAndColors.forEach { (position, color) in
                resizedBrickImage.cgImage?.filled(with: color)?.draw(at: position)
            }
        }
        return image
    }
    
    func calculateTilePositionsAndColors(image: UIImage, tileSize: CGSize) -> [CGPoint: UIColor] {
        var result: [CGPoint: UIColor] = [:]
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

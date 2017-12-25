//
//  LegofyService.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/25/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

private enum MeasureOperation {
    static let imageGeneration = "UIImage generation"
    static let tilesGeneration = "Tiles generation"
}

protocol LegofyServiceDelegate: class {
    func legofyServiceDidUpdateProgress(progress: Float)
    func legofyServiceDidRenderImage(image: UIImage)
    func legofyServiceDidGenerateTiles(positionsAndTiles: [CGPoint: UIImage])
}

protocol LegofyProtocol {
    var delegate: LegofyServiceDelegate? { get set }
    var isPercentValueProgressEnabled: Bool { get set }
    func generateImage()
    func generateBrickTiles()
    func setOutputSize(_ size: CGSize)
    func setBrickSize(_ size: CGFloat)
}

final class LegofyService: LegofyProtocol {
    
    weak var delegate: LegofyServiceDelegate?
    
    var isPercentValueProgressEnabled: Bool = false
    
    /* Should be service provided image */
    private let _sourceBrickImage = #imageLiteral(resourceName: "lego-brick-tile-bw")
    
    private let _sourceImage: UIImage
    private var _outputSize: CGSize
    private var _brickSize: CGFloat
    
    private var _fitSourceImage: UIImage {
        let resizedSourceImage = _sourceImage.resize(toFit: _outputSize.width)
        return resizedSourceImage
    }
    
    private var _fitBrickImage: UIImage {
        let resizedBrickImage = _sourceBrickImage.resize(toFit: _brickSize)
        return resizedBrickImage
    }
    
    private var _progress: Float = 0.0 {
        didSet {
            var progress = _progress
            if isPercentValueProgressEnabled { progress = _progress.roundTo(2) * 100 }
            delegate?.legofyServiceDidUpdateProgress(progress: progress)
        }
    }
    
    init(sourceImage: UIImage, outputSize: CGSize, brickSize: CGFloat) {
        self._sourceImage = sourceImage
        self._outputSize = outputSize
        self._brickSize = brickSize
    }
    
    /*
     * 1. Calculating columns and rows count in order to produce tiles
     * 2. Calculating dominant colors and positions for tiles
     * 3. Assembling images and positions in dictionary
     * 4. Calling delegate method
     */
    func generateBrickTiles() {
        /* Progress tracking start */
        _progress = 0.001
        
        measure(MeasureOperation.tilesGeneration) {
        
            let resizedBrickImage = _fitBrickImage
            var positionsAndTiles: [CGPoint: UIImage] = [:]
            calculateTilePositionsAndColors(image: _fitSourceImage, tileSize: resizedBrickImage.size).forEach { (position, color) in
                positionsAndTiles[position] = resizedBrickImage.cgImage?.filled(with: color)
            }

            delegate?.legofyServiceDidGenerateTiles(positionsAndTiles: positionsAndTiles)
        }
    }
    
    /*
     * 1. Generating the future legofied image (blank)
     * 2. Calculating dominant colors and positions for tiles to be rendered in an image
     * 3. Initializing graphics renderer for creating Core Graphics-backed image
     * 4. Rendering image with calculated components
     * 5. Calling delegate method
     */
    func generateImage() {
        /* Progress tracking start */
        _progress = 0.001
        
        measure(MeasureOperation.imageGeneration) {
            
            let resizedBrickImage = _fitBrickImage
            let positionsAndColors = calculateTilePositionsAndColors(image: _fitSourceImage, tileSize: resizedBrickImage.size)
            let image = renderImage(with: positionsAndColors)

            delegate?.legofyServiceDidRenderImage(image: image)
        }
    }
    
    func setOutputSize(_ size: CGSize) {
        self._outputSize = size
    }
    
    func setBrickSize(_ size: CGFloat) {
        self._brickSize = size
    }
}

private extension LegofyService {
    func renderImage(with positionsAndColors: [CGPoint: UIColor]) -> UIImage {
        
        /* Progress tracking */
        let progressFraction: Float = 0.5 / Float(positionsAndColors.count - 1)
        
        let renderer = UIGraphicsImageRenderer(size: self._outputSize, format: .default())
        let image: UIImage = renderer.image { (context) in
            let fillRect = CGRect(origin: .zero, size: self._outputSize)
            UIColor.white.setFill()
            context.fill(fillRect)
            
            let resizedBrickImage = _fitBrickImage.cgImage
            
            positionsAndColors.forEach { (position, color) in
                resizedBrickImage?.filled(with: color)?.draw(at: position)
                
                /* Progress tracking (tile component colored) */
                if _progress < 1.0 {
                    _progress += progressFraction
                }
            }
        }
        return image
    }
    
    func calculateTilePositionsAndColors(image: UIImage, tileSize: CGSize) -> [CGPoint: UIColor] {
        var result: [CGPoint: UIColor] = [:]
        let grid = calculateColumnsAndRows(for: image, withTileSize: tileSize)
        
        let remainerW: CGFloat = image.size.width  - (CGFloat(grid.columns) * tileSize.width)
        let remainerH: CGFloat = image.size.height - (CGFloat(grid.rows)    * tileSize.height)
        
        /* Progress tracking */
        let progressFraction: Float = 0.5 / Float(grid.rows - 1)
        
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
            
            /* Progress tracking (row completion) */
            if _progress < 1.0 {
                _progress += progressFraction
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

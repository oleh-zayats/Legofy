//
//  LegofyService.swift
//  SwiftyLegofy
//
//  Created by Oleh Zayats on 12/25/17.
//  Copyright © 2017 Oleh Zayats. All rights reserved.
//

import UIKit

public enum BlendMode {
    case multiply, hardLight, colorBurn, difference
}

public enum BrickType {
    case clean, legoV1, legoV2, legoV3, custom(UIImage)
}

public protocol LegofyServiceDelegate: class {
    func legofyServiceDidUpdateProgress(_ progress: Float)
    func legofyServiceDidFinishGeneratingImage(_ image: UIImage)
    func legofyServiceDidFinishGeneratingTileImages(_ positionsAndTiles: [CGPoint: UIImage])
}

public final class LegofyService: LegofyServiceProtocol {
    private enum OperationName {
        static let imageGeneration = "Image generation"
        static let tilesGeneration = "Brick tiles generation"
    }
    
    public weak var delegate: LegofyServiceDelegate?
    
    public var isPercentProgressEnabled: Bool = false
    
    private let _sourceImage: UIImage
    private var _outputSize: CGSize
    private var _brickSize: CGFloat
    private var _brickType: BrickType
    private var _blendMode: CGBlendMode = .multiply
    
    private var _sourceBrickImage: UIImage {
        switch _brickType {
        case .clean:
            return UIImage(named: "brick-lego-clean")!
        case .legoV1:
            return UIImage(named: "brick-lego-v1")!
        case .legoV2:
            return UIImage(named: "brick-lego-v2")!
        case .legoV3:
            return UIImage(named: "brick-lego-v3")!
        case .custom(let image):
            return image
        }
    }
    
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
            var progress = _progress.roundTo(3)
            if isPercentProgressEnabled { progress = _progress.roundTo(2) * 100 }
            delegate?.legofyServiceDidUpdateProgress(progress)
        }
    }
    
    public init(sourceImage: UIImage, outputSize: CGSize? = nil, brickSize: CGFloat = 20.0, brickType: BrickType = .clean, blendMode: BlendMode = .multiply) {
        self._sourceImage = sourceImage
        self._outputSize = outputSize ?? sourceImage.size
        self._brickSize = brickSize
        self._brickType = brickType
        self.setBlendMode(blendMode)
    }
    
    /*
     * 1. Calculating columns and rows count in order to produce tiles
     * 2. Calculating dominant colors and positions for tiles
     * 3. Assembling images and positions in dictionary
     * 4. Calling delegate method
     */
    public func generateBrickTileImages() {
        /* Progress tracking start */
        _progress = 0.001
        
        measure(OperationName.tilesGeneration) {
            
            let resizedBrickImage = _fitBrickImage
            var positionsAndTileImagess: [CGPoint: UIImage] = [:]
            calculateTilePositionsAndColors(image: _fitSourceImage, tileSize: resizedBrickImage.size).forEach { (arguments) in
                
                let (position, color) = arguments
                positionsAndTileImagess[position] = resizedBrickImage.cgImage?.filled(with: color, blendMode: _blendMode)
            }
            delegate?.legofyServiceDidFinishGeneratingTileImages(positionsAndTileImagess)
        }
    }
    
    /*
     * 1. Calculating dominant colors and positions for tiles to be rendered
     * 2. Initializing graphics renderer for creating Core Graphics-backed image
     * 3. Rendering image with calculated components
     * 4. Calling delegate method
     */
    public func generateImage() {
        /* Progress tracking start */
        _progress = 0.001
        
        measure(OperationName.imageGeneration) {
            
            let resizedBrickImage = _fitBrickImage
            let positionsAndColors = calculateTilePositionsAndColors(image: _fitSourceImage, tileSize: resizedBrickImage.size)
            let renderedImage = renderImage(with: positionsAndColors)
            
            delegate?.legofyServiceDidFinishGeneratingImage(renderedImage)
        }
    }
    
    public func setOutputSize(_ size: CGSize) {
        _outputSize = size
    }
    
    public func setBrickSize(_ size: CGFloat) {
        _brickSize = size
    }
    
    public func setBrickType(_ type: BrickType) {
        _brickType = type
    }
        
    public func setBlendMode(_ mode: BlendMode) {
        switch mode {
        case .multiply:
            _blendMode = .multiply
        case .difference:
            _blendMode = .difference
        case .hardLight:
            _blendMode = .hardLight
        case .colorBurn:
            _blendMode = .colorBurn
        }
    }
}

private extension LegofyService {
    func renderImage(with positionsAndColors: [CGPoint: UIColor]) -> UIImage {
        
        /* Progress tracking */
        let progressFraction: Float = 0.5 / Float(positionsAndColors.count - 1)
        
        let renderer = UIGraphicsImageRenderer(size: _outputSize, format: .default())
        let image: UIImage = renderer.image { (context) in
            
            let resizedBrickImage = _fitBrickImage.cgImage
            
            positionsAndColors.forEach { (position, color) in
                resizedBrickImage?.filled(with: color, blendMode: _blendMode)?.draw(at: position)
                
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
        
        let columns: CGFloat = image.size.width  / tileSize.width
        let rows:    CGFloat = image.size.height / tileSize.height
        
        var completeColumns: Int = Int(floorf(Float(columns)))
        var completeRows:    Int = Int(floorf(Float(rows)))
        
        if columns > CGFloat(completeColumns) { completeColumns += 1 }
        if rows    > CGFloat(completeRows)    { completeRows    += 1 }
        
        return (rows: completeRows, columns: completeColumns)
    }
}

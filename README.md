# Legofy

![License](https://img.shields.io/badge/Licence-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
![Language](https://img.shields.io/badge/language-swift%204.0-orange.svg)
![Dependencies](https://img.shields.io/badge/Dependencies-None-lightgray.svg)


![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Examples/Legofy.png)

# Installation:
1. Install using [CocoaPods](https://cocoapods.org):<br/>Add the following line to the project's Podfile:
```pod 'Legofy'```<br/>
run ```pod install```<br/>

2. Manually:<br/> Drag Classes folder to your project directory and add brick images from Resources into Assets folder of the project.

# How To Use:
Import module:
```swift
import Legofy
```
Initialize service:
```swift
let legofyService = LegofyService(sourceImage: srcImage, brickSize: 50.0, brickType: .legoV2)
```
Setup delegate:
```swift
legofyService?.delegate = self
```

Use isPercentProgressEnabled to get progress in percents instaed of default Float value
```swift
legofyService?.isPercentProgressEnabled = true
```

Brick types available:
```swift
enum BrickType {
    case clean, legoV1, legoV2, legoV3, custom(UIImage)
}
```

Blend modes available:
```swift
enum BlendMode {
    case multiply, hardLight, colorBurn, difference
}
```

Call 'generateImage' to generate image:
```swift
legofyService?.generateImage()
```

Or 'generateBrickTileImages' to generate brick tiles and positions (columns/rows):
```swift
legofyService?.generateBrickTileImages() 
```

## Check out the project in 'Demo' folder. <br/>
Don't forget to run ```pod install``` in Demo directory ^^ <br/>
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Examples/Legofy.gif)
<br/><br/>


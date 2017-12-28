# Legofy

![License](https://img.shields.io/badge/Licence-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
![Language](https://img.shields.io/badge/language-swift%204.0-orange.svg)
![CocoaPod](https://img.shields.io/badge/pod-0.3.0-red.svg)
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
Initialize service with:
```swift
init(sourceImage: UIImage, outputSize: CGSize? = nil, brickSize: CGFloat = 20.0, brickType: BrickType = .clean, blendMode: BlendMode = .multiply)
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

Check out the project in 'Demo' folder. <br/>
Don't forget to run ```pod install``` in Demo directory ^^ <br/>
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Examples/Legofy.gif)
<br/><br/>

:construction: Work in progress...

# TODO: 
1. Make a nice project structure. :heavy_check_mark: <br/>
2. Add Example Folder with CocoaPod usage. :heavy_check_mark: <br/>
3. Write some simple Unit Tests. <br/>
4. Describe component in Readme. :heavy_check_mark: <br/>
5. Add more brick assets to choose from, or maybe pdf/svg for scalability. :heavy_check_mark: <br/>
6. Add output image adjustment possibilities (enchance image, change blend mode?). :heavy_check_mark: <br/>

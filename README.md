# Legofy

![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Examples/Legofy.png)

# How To Use:
```swift
/* Initialize service */
legofyService = LegofyService(sourceImage: image, outputSize: outputSize, brickSize: 15.0)
legofyService?.delegate = self

/* Use isPercentProgressEnabled to get progress in percents instaed of default Float value */
legofyService?.isPercentProgressEnabled = true

/* Brick types available out of the box */
clean, legoV1, legoV2, legoV3

/* Call 'generateImage' to generate whole image... */
legofyService?.generateImage()

/* ... or 'generateBrickTileImages' to generate brick tiles 
 * and positions (columns/rows) within output rect */
legofyService?.generateBrickTileImages() 

```

![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Examples/Legofy.gif)

# TODO: 
1. Make a nice project structure. :heavy_check_mark: <br/>
2. Add Example Folder with CocoaPod usage. :heavy_check_mark: <br/>
3. Write some simple Unit Tests. <br/>
4. Describe component in Readme. <br/>
5. Add more brick assets to choose from, or maybe pdf/svg for scalability. :heavy_check_mark: <br/>
6. Add output image adjustment possibilities (enchance image, change blend mode?). <br/>

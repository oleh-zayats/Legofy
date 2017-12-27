# Legofy
Process any image to look like it's made out of LEGO blocks.
Choose block size, look and adjust the result.

:construction: Work In Progress...

![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/00-original.jpg)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/01-render.png)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/02-render.png)

# How To Use (WIP):
```swift
/* Initialize service */
legofyService = LegofyService(sourceImage: image, outputSize: outputSize, brickSize: 15.0)
legofyService?.delegate = self

/* Use isPercentProgressEnabled to get progress in percents instaed of default Float value */
legofyService?.isPercentProgressEnabled = true

/* Call 'generateImage' to generate whole image... */
legofyService?.generateImage()

/* ... or 'generateBrickTileImages' to generate brick tiles 
 * and positions (columns/rows) within output rect */
legofyService?.generateBrickTileImages() 
```

# TODO: 
1. Make a nice project structure.
2. Add Example Folder with CocoaPod usage.
3. Write some simple Unit Tests.
4. Describe component in Readme.
5. Add more brick assets to choose from, or maybe pdf/svg for scalability.
6. Add output image adjustment possibilities (enchance image, change blend mode?).

# Legofy
Turn any image into lego block grid.

# How to use:
```
// init service
legofyService = LegofyService(sourceImage: image, outputSize: outputSize, brickSize: 15.0)
legofyService?.delegate = self

// use isPercentProgressEnabled to update progress in percents
legofyService?.isPercentProgressEnabled = true

// call 'generateImage' to generate whole image or
legofyService?.generateImage()

// or 'generateBrickTileImages' to generate brick tiles 
// and positions (columns/rows) within output rect
legofyService?.generateBrickTileImages() 
```

![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/00-original.jpg)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/01-render.png)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/02-render.png)


# Legofy
Turn any image into lego block grid.

![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/00-original.jpg)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/01-render.png)
![alt text](https://github.com/oleh-zayats/Legofy/blob/master/Resources/02-render.png)

# Usage:
```
// Initialize service
legofyService = LegofyService(sourceImage: image, outputSize: outputSize, brickSize: 15.0)
legofyService?.delegate = self

// Use isPercentProgressEnabled to get progress in percents instaed of default Float value
legofyService?.isPercentProgressEnabled = true

// Call 'generateImage' to generate whole image or
legofyService?.generateImage()

// OR 'generateBrickTileImages' to generate brick tiles 
// and positions (columns/rows) within output rect
legofyService?.generateBrickTileImages() 
```


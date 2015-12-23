//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!

let i = RGBAImage(image: image)!

let imageProcessor = ImageProcessor()

//let filter1 = ClearChannelFilter(channel: Channel.BLUE)
//let newImage1 = imageProcessor.apply(image, filters:filter1)
//
//let filter2 = SharpenFilter(value: 0)
//let newImage2 = imageProcessor.apply(image, filters:filter2)
//
//let filter3 = GreyScaleFilter()
//let newImage3 = imageProcessor.apply(image, filters:filter3)

//            pixel.red = calc.calculate(39.3, greenPart:34.9, bluePart: 27.2)

let newImage4 = imageProcessor.apply(image, filters:SepiaFilter(depth: 50))

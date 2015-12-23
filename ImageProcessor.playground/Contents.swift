//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!

let i = RGBAImage(image: image)!

let imageProcessor = ImageProcessor()
let filter1 = ClearChannelFilter(channel: Channel.BLUE)
let filter2 = SharpenFilter(middleColor: 126)

print(UINT8_MAX)

let newImage = imageProcessor.apply(image, filters:filter2)

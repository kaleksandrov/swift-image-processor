//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!

let i = RGBAImage(image: image)!

let imageProcessor = ImageProcessor()
let filter = ClearColorFilter()

let newImage = imageProcessor.apply(image, filters:filter)
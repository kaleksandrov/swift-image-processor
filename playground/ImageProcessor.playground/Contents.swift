//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Create the ImageProcessor instance.
let imageProcessor = ImageProcessor()

// Apply a single predefined filter.
let newImage1 = imageProcessor.apply(image, filters:Filters.GREY_SCALE_0)

// Apply a several predefined filters.
let newImage2 = imageProcessor.apply(image, filters:Filters.CLEAR_RED, Filters.SHARPEN_80, Filters.SEPIA_50)

// Create a custom filter and apply it.
let sepia80 = SharpenFilter(50)
let newImage3 = imageProcessor.apply(image, filters:sepia80)

// Create several custom filters and apply them.
let grey60 = GreyFilter(60)
let invert = InvertFilter(10)
let newImage4 = imageProcessor.apply(image, filters:grey60, invert)

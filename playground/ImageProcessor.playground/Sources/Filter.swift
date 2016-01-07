import Foundation
import UIKit

/// An extension to the RGBAImage that adds some useful
/// methods for easy processing of the pixel matrix
public extension RGBAImage {

    /// Calculates the index for the
    public func calculateIndexFor(x:Int, y:Int) -> Int {
        return x * self.width + y
    }
    
    /// Calls the given callback function for each pixel of the image matrix
    /// - parameter callback: The logic to be executed for each pixel.
    public func process(callback:(inout Pixel) -> ()) {
        for x in 0..<self.width {
            for y in 0..<self.height {
                let index = calculateIndexFor(x, y:y)
                var pixel = self.pixels[index]
                
                callback(&pixel)
                
                self.pixels[index] = pixel
            }
        }
    }
}

/// List of the pixel channels
public enum Channel {
    case RED
    case GREEN
    case BLUE
}

/// Defines an image filter.
public protocol Filter {
    
    /// Applies the current filter effect to the given image.
    /// - parameter image: An instance of RGBAImage
    func apply(image:RGBAImage)
}

/// A filter implementation that clears one of the color channels of the pixel.
public class ClearChannelFilter:Filter {
    
    public var channel: Channel
    
    public init(channel:Channel) {
        self.channel = channel
    }
    
    public convenience init(_ channel:Channel) {
        self.init(channel:channel)
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            switch self.channel {
            case .RED:
                pixel.red = 0
            case .GREEN:
                pixel.green = 0
            case .BLUE:
                pixel.blue = 0
            }
        })
    }
}

// Makes the image a black&white one.
public class GreyFilter:Filter {
    
    var depth:Int
    
    public init(depth:Int) {
        self.depth = depth
    }
    
    public convenience init(_ depth:Int) {
        self.init(depth:depth)
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            let red = Int(pixel.red)
            let green = Int(pixel.green)
            let blue = Int(pixel.blue)
            
            // The grey color is an avarage value between the
            // three color channels.
            let grey = safeCast((red + green + blue)/3 + self.depth)
            
            // Assign the same value to all color channels.
            pixel.red = grey
            pixel.green = grey
            pixel.blue = grey
        })
    }
}

// Adds a sepia effect to the image.
public class SepiaFilter:Filter {
    
    /// The depth of the effect. The bigger the value, the older the image looks.
    var depth:Int
    
    public init(depth:Int) {
        self.depth = depth
    }
    
    public convenience init(_ depth:Int) {
        self.init(depth:depth)
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            var red = Int(pixel.red)
            var green = Int(pixel.green)
            var blue = Int(pixel.blue)
            
            // The grey color is an avarage value between the
            // three color channels.
            let grey = (red + green + blue)/3
            
            // Calculate the new color channels.
            red = grey + self.depth * 2
            green = grey + self.depth
            blue = grey - self.depth
            
            // Apply the changes to the pixel.
            pixel.red = safeCast(red)
            pixel.green = safeCast(green)
            pixel.blue = safeCast(blue)
        })
    }
}

/// Inverts the colors of the image and adds an optional offset.
public class InvertFilter:Filter {
    
    var depth:Int
    
    public init(depth:Int) {
        self.depth = depth
    }
    
    public convenience init(_ depth:Int) {
        self.init(depth:depth)
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            // Substract the color value from the maximum value (255) and add the depth
            pixel.red = safeCast(Int(UINT8_MAX) - Int(pixel.red) + self.depth)
            pixel.green = safeCast(Int(UINT8_MAX) - Int(pixel.green) + self.depth)
            pixel.blue = safeCast(Int(UINT8_MAX) - Int(pixel.blue) + self.depth)
        })
    }
}

/// Sharpens image's colors.
public class SharpenFilter:Filter {
    
    var depth:Int
    
    public init(depth:Int) {
        self.depth = depth
    }
    
    public convenience init(_ depth:Int) {
        self.init(depth:depth)
    }
    
    public func apply(image:RGBAImage) {
        var allRed = 0;
        var allGreen = 0;
        var allBlue = 0;
        
        image.process({
            (inout pixel:Pixel) -> () in
            allRed += Int(pixel.red)
            allGreen += Int(pixel.green)
            allBlue += Int(pixel.blue)
        })
        
        let count = image.pixels.count
        
        let avgRed = allRed/count
        let avgGreen = allGreen/count
        let avgBlue = allBlue/count
        
        image.process({
            (inout pixel:Pixel) -> () in
            pixel.red = self.enchance(pixel.red, avg: avgRed)
            pixel.green = self.enchance(pixel.green, avg:avgGreen)
            pixel.blue = self.enchance(pixel.blue, avg: avgBlue)
        })
    }
    
    private func enchance(color:UInt8, avg:Int) -> UInt8 {
        let col = Int(color)
        
        if (col > avg) {
            return safeCast(col + self.depth)
        } else if (col < avg) {
            return safeCast(col - self.depth)
        } else {
            // Leave it as it is.
            return color
        }
    }
}

/// Contains a number of predefined filters that are ready to use.
public class Filters {
    /// A simple Grey Scale filter.
    public static let GREY_SCALE_0 = GreyFilter(depth: 0)
    
    /// A Grey Scale filter that increases the grey with 50 points.
    public static let GREY_SCALE_50 = GreyFilter(depth: 50)
    
    /// A Grey Scale filter that increases the grey with 100 points.
    public static let GREY_SCALE_100 = GreyFilter(depth: 100)

    /// Clears the RED color channel.
    public static let CLEAR_RED = ClearChannelFilter(channel: Channel.RED)
    
    /// Clears the GREEN color channel.
    public static let CLEAR_GREEN = ClearChannelFilter(channel: Channel.GREEN)
    
    /// Clears the BLUE color channel.
    public static let CLEAR_BLUE = ClearChannelFilter(channel: Channel.BLUE)
    
    /// Applies a Sepia effect with depth 30.
    public static let SEPIA_30 = SepiaFilter(depth: 30)
    
    /// Applies a Sepia effect with depth 50.
    public static let SEPIA_50 = SepiaFilter(depth: 50)
    
    /// Applies a Sepia effect with depth 100.
    public static let SEPIA_100 = SepiaFilter(depth: 100)
    
    /// Inverts image colors.
    public static let INVERT_0 = InvertFilter(0)
    
    /// Inverts image colors and adds an offset of 20 points.
    public static let INVERT_20 = InvertFilter(20)
    
    /// Inverts image colors and adds an offset of 50 points.
    public static let INVERT_50 = InvertFilter(50)

    // Enchances image colors with 30 points.
    public static let SHARPEN_30 = SharpenFilter(30)
    
    // Enchances image colors with 80 points.
    public static let SHARPEN_80 = SharpenFilter(80)
}

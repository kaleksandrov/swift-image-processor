import Foundation
import UIKit

public extension RGBAImage {
    
    private func calculateIndexFor(x:Int, y:Int) -> Int {
        return x * self.width + y
    }
    
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


public protocol Filter {
    func apply(image:RGBAImage)
}


public class ImageProcessor {

    public init() {
        
    }
    
    public func apply(image:UIImage, filters:Filter...) -> UIImage{
        // 1. Convert to RGBAImage.
        let rgbaImage = RGBAImage(image:image)!
        
        // 2. Apply the change to each pixel.
        for filter in filters {
            filter.apply(rgbaImage)
        }
        
        // 3. Convert back to UIImage.
        return rgbaImage.toUIImage()!
    }
}

public enum Channel {
    case ALFA
    case RED
    case GREEN
    case BLUE
}

public class ClearChannelFilter:Filter {

    
    public var channel: Channel
    
    public init(channel:Channel) {
        self.channel = channel
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            switch self.channel {
            case .ALFA:
                pixel.alpha = 0
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

public class GreyScaleFilter:Filter {
    
    public init() {
        
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            let red = Int(pixel.red)
            let green = Int(pixel.green)
            let blue = Int(pixel.blue)
            
            let grey = (red + green + blue)/3
            
            pixel.red = UInt8(grey)
            pixel.green = UInt8(grey)
            pixel.blue = UInt8(grey)
        })
    }
}



public class SepiaFilter:Filter {
    
    var depth:UInt8
    
    public init(depth:UInt8) {
        self.depth = depth
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            var red = Int(pixel.red)
            var green = Int(pixel.green)
            var blue = Int(pixel.blue)
            
            let grey = (red + green + blue)/3
            
            red = grey + Int(self.depth) * 2
            green = grey + Int(self.depth)
            blue = grey - Int(self.depth)
            
            pixel.red = UInt8(self.norm(red))
            pixel.green = UInt8(self.norm(green))
            pixel.blue = UInt8(self.norm(blue))
        })
    }
    
    private func norm(color:Int) -> UInt8 {
        return UInt8(max(min(color, 255), 0))
    }
}

public class InvertFilter:Filter {
    
    public init() {
        
    }
    
    public func apply(image:RGBAImage) {
        image.process({
            (inout pixel:Pixel) -> () in
            let red = Int(pixel.red)
            let green = Int(pixel.green)
            let blue = Int(pixel.blue)
            
            pixel.red = UInt8(255 - red)
            pixel.green = UInt8(255 - green)
            pixel.blue = UInt8(255 - blue)
        })
    }
}


public class SharpenFilter:Filter {
    
    var value:UInt8
    
    public init(value:UInt8) {
        self.value = value
    }
    
    public func apply(image:RGBAImage) {
        var allRed = 0;
        
        image.process({
            (inout pixel:Pixel) -> () in
            allRed += Int(pixel.red)
        })
        
        let count = image.pixels.count
        
        let avgRed = UInt8(allRed/count)
        
        image.process({
            (inout pixel:Pixel) -> () in
            pixel.red = self.calculateColor(pixel.red, treshold: avgRed)
        })
    }
    
    private func calculateColor(color:UInt8, treshold:UInt8) -> UInt8 {
        let iColor = Int(color)
        let iTreshold = Int(treshold)
        let diff = iColor - iTreshold
        
        if diff > 0 {
            return UInt8(min(iColor + Int(self.value), Int(UINT8_MAX)))
        } else if diff < 0 {
            return UInt8(max(iColor - Int(self.value), 0))
        } else {
            return color
        }
    }
    
}

import Foundation
import UIKit

public protocol Filter {
    func apply(inout pixel:Pixel)
}

public class ImageProcessor {

    public init() {
        
    }
    
    public func apply(image:UIImage, filters:Filter...) -> UIImage{
        // 1. Convert to RGBAImage.
        let rgbaImage = RGBAImage(image:image)!
        
        // 2. Apply the change to each pixel.
        for x in 0..<rgbaImage.width {
            for y in 0..<rgbaImage.height {
                let index = x*rgbaImage.width + y
                var pixel = rgbaImage.pixels[index]
                
                
                for filter in filters {
                    filter.apply(&pixel)
                }
                
                rgbaImage.pixels[index] = pixel
            }
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
    
    public func apply(inout pixel:Pixel) {
        switch channel {
        case .ALFA:
            pixel.alpha = 0
        case .RED:
            pixel.red = 0
        case .GREEN:
            pixel.green = 0
        case .BLUE:
            pixel.blue = 0
        }
    }
}

public class SharpenFilter:Filter {
    
    var middleColor:UInt8
    
    public init(middleColor:UInt8) {
        self.middleColor = middleColor
    }
    
    public func apply(inout pixel:Pixel) {
//        pixel.red /= 2
//        pixel.green /= 2
//        pixel.blue /= 2
        
        let diff:Int = Int(pixel.red) - Int(self.middleColor)
        print("-----")
        print(pixel.red)
        print(diff)
//        print(Int(pixel.red) + Int(diff))
//        print(min(Int(pixel.red) + Int(diff), 255))
//        print(          UInt8(min(Int(pixel.red) + Int(diff), 255))        )
        if(diff > 0) {
            print("1")
            pixel.red = UInt8(min(Int(pixel.red) + Int(diff), 255))
            print(pixel.red)
        } else {
            print("2")
            pixel.red = UInt8(max(Int(pixel.red) - Int(diff), 0))
        }
    }
}

import Foundation
import UIKit

public protocol Filter {
     func apply(inout pixel:Pixel)
    func configure(image:RGBAImage)
}

public class ImageProcessor {
    public init() {
        
    }
    
    public func apply(image:UIImage, filters:Filter...) -> UIImage{
        let rgbaImage = RGBAImage(image:image)!
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
        
        return rgbaImage.toUIImage()!
    }
}

public class ClearColorFilter:Filter {
    
    public init() {
        
    }
    
    public func configure(image:RGBAImage){
        // TODO [kaleksandrov]: Implement!!!
    }
    
    public func apply(inout pixel:Pixel) {
        pixel.red = UInt8(0)
    }
}

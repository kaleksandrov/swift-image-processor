import Foundation
import UIKit

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
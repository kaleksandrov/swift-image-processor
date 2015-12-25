import Foundation

/// Converts safely an Int number to an UInt8 one
/// without crossing the type boundaries.
/// - parameter color: The Int color value.
/// - returns: The color value converted to UInt8 number.
public func safeCast(color:Int) -> UInt8 {
    return UInt8(max(min(color, 255), 0))
}
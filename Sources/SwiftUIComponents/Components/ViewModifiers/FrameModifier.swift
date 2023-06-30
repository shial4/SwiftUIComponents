import SwiftUI

/**
 A view modifier that applies a frame transformation to a view.
 
 Use the `FrameModifier` view modifier to apply translation, rotation, and scaling transformations to a view.
 
 ## Overview
 The `FrameModifier` view modifier allows you to specify the offset, rotation, scale, and anchor point of a view. It applies these transformations to the view, allowing you to position and transform the view within its container.
 
 ### Example Usage:
 ```swift
 Text("Hello, SwiftUI!")
     .modifier(FrameModifier(
         offset: CGSize(width: 10, height: 20),
         rotation: Angle(degrees: 45),
         scale: CGSize(width: 2, height: 2),
         anchor: .center)
     )
 ```
 
 ### Remark:
 The `FrameModifier` view modifier is created by providing the offset, rotation, scale, and anchor properties.
 
 - Note: The `FrameModifier` view modifier applies the specified offset, rotation, and scale transformations to the view it is applied to. The anchor property determines the pivot point for the rotation and scaling operations.
 
 */
public struct FrameModifier: ViewModifier {
    public let offset: CGSize
    public let rotation: Angle
    public let scale: CGSize
    public let anchor: UnitPoint
    
    /**
     Initializes a `FrameModifier` view modifier with the specified offset, rotation, scale, and anchor values.
     
     - Parameters:
     - offset: The translation offset to apply to the view.
     - rotation: The rotation angle to apply to the view.
     - scale: The scaling factor to apply to the view.
     - anchor: The anchor point around which the rotation and scaling operations are performed.
     
     - Returns: A `FrameModifier` view modifier with the specified offset, rotation, scale, and anchor values.
     */
    public init(offset: CGSize,
                rotation: Angle,
                scale: CGSize,
                anchor: UnitPoint) {
        self.offset = offset
        self.rotation = rotation
        self.scale = CGSize(width: scale.width == 0 ? 0.001 : scale.width, 
                            height: scale.height == 0 ? 0.001 : scale.height)
        self.anchor = anchor
    }
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(rotation, anchor: anchor)
            .offset(x: offset.width, y: offset.height)
            .scaleEffect(scale, anchor: anchor)
    }
}

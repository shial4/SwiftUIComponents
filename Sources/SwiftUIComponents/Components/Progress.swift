import SwiftUI

/**
 A custom progress view that renders a shape with a progress indicator.

 Use the `Progress` view to display a shape with a progress indicator, such as a circular progress bar or a linear progress bar.

 ## Overview
 The `Progress` view allows you to customize the appearance of the progress indicator by providing a shape and specifying the progress value.

 ### Example Usage:
 ```swift
 Progress(progress: $progress, content: Rectangle())
 .frame(width: 150, height: 150)
 .foregroundStyle(.red)
 .backgroundStyle(.blue)
```

### Remark:
 The Progress view is created by providing a binding to the progress value, a shape as the content, and an optional stroke style.

 Note: To customize the appearance of the progress indicator, you can provide a StrokeStyle or use the default style with a specific line width.
 */
public struct Progress<Content: Shape>: View {
    @Binding private var progress: Double
    private let style: StrokeStyle
    private let content: Content

    /**
     Initializes a `Progress` view with a progress value binding, shape content, and default stroke style.

     - Parameters:
     - progress: A binding to the progress value that controls the progress indicator.
     - content: The shape content to be displayed as the progress indicator.
     - lineWidth: The width of the stroke used to render the progress indicator. The default value is 6.

     - Returns: A `Progress` view with the specified progress value, shape content, and stroke style.
     */
    public init(progress: Binding<Double>, content: Content, lineWidth: Double = 6) {
        self._progress = progress
        self.content = content
        self.style = StrokeStyle(lineWidth: lineWidth,
                                 lineCap: CGLineCap.round,
                                 lineJoin: CGLineJoin.round,
                                 miterLimit: 0,
                                 dash: [],
                                 dashPhase: 0)
    }

    /**
     Initializes a `Progress` view with a progress value binding, shape content, and custom stroke style.

     - Parameters:
     - progress: A binding to the progress value that controls the progress indicator.
     - content: The shape content to be displayed as the progress indicator.
     - style: The stroke style used to render the progress indicator.

     - Returns: A `Progress` view with the specified progress value, shape content, and stroke style.
     */
    public init(progress: Binding<Double>, content: Content, style: StrokeStyle) {
        self._progress = progress
        self.content = content
        self.style = style
    }

    static func normalized(_ value: Double) -> Double {
        value.isFinite ? min(1, max(0, value)) : 0
    }

    public var body: some View {
        let value = Self.normalized(progress)
        return ZStack {
            content
                .stroke(BackgroundStyle.background, style: style)
            content
                .trim(from: 0, to: value)
                .stroke(ForegroundStyle.foreground, style: style)
        }
        .componentAccessibilityChildren(.ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(Text(verbatim: value.formatted(.percent.precision(.fractionLength(0)))))
    }
}

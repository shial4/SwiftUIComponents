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
    @Binding var progress: Double
    var style: StrokeStyle
    var content: Content
    
    /**
     Initializes a `Progress` view with a progress value binding, shape content, and default stroke style.
     
     - Parameters:
     - progress: A binding to the progress value that controls the progress indicator.
     - content: The shape content to be displayed as the progress indicator.
     - lineWidth: The width of the stroke used to render the progress indicator. The default value is 6.
     
     - Returns: A `Progress` view with the specified progress value, shape content, and stroke style.
     */
    public init(progress: Binding<Double>, content: Content, lineWidth: CGFloat = 6) {
        self._progress = progress
        self.content = content
        self.style = StrokeStyle(lineWidth: lineWidth, 
                                 lineCap: .round, 
                                 lineJoin: .round, 
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
    
    public var body: some View {
        ZStack {
            content
                .stroke(.background, style: style)
            content
                .trim(from: 0, to: CGFloat(progress))
                .stroke(.foreground, style: style)
        }
    }
}

struct Progress_Previews: PreviewProvider {
    @State static var progress: Double = 0.4
    
    static var previews: some View {
        VStack(spacing: 20) {
            Text("\(Int(progress * 100))%")
                .font(.title)
                .bold()
            Progress(progress: $progress, content: Circle())
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
            Progress(progress: $progress, content: Rectangle())
                .frame(width: 150, height: 150)
                .foregroundStyle(.red)
                .backgroundStyle(.blue)
            Progress(progress: $progress, content: Rectangle())
                .frame(width: 150, height: 1)
            Button("Increase Progress") {
                progress += 0.1
            }
            Button("Reset Progress") {
                progress = 0.0
            }
        }
        .padding()

    }
}
